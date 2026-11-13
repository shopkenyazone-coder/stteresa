<?php

declare(strict_types=1);

namespace STA;

use PDO;
use PDOStatement;
use RuntimeException;

/**
 * PDO connection and small query helpers.
 *
 * Every query is prepared. Emulated prepares are disabled so MySQL
 * really prepares the statement server-side.
 */
final class Database
{
    private static ?PDO $pdo = null;

    public static function pdo(): PDO
    {
        if (self::$pdo instanceof PDO) {
            return self::$pdo;
        }

        $host    = (string) Config::get('db.host', '127.0.0.1');
        $port    = (int) Config::get('db.port', 3306);
        $name    = (string) Config::get('db.name', 'sta_school');
        $charset = (string) Config::get('db.charset', 'utf8mb4');

        $dsn = sprintf('mysql:host=%s;port=%d;dbname=%s;charset=%s', $host, $port, $name, $charset);

        try {
            self::$pdo = new PDO(
                $dsn,
                (string) Config::get('db.user', 'root'),
                (string) Config::get('db.pass', ''),
                [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                    PDO::ATTR_STRINGIFY_FETCHES  => false,
                ]
            );
        } catch (\PDOException $e) {
            error_log('Database connection failed: ' . $e->getMessage());
            throw new RuntimeException('The database is unavailable. Please try again later.', 0, $e);
        }

        return self::$pdo;
    }

    /** @param array<int|string, mixed> $params */
    public static function query(string $sql, array $params = []): PDOStatement
    {
        $statement = self::pdo()->prepare($sql);

        foreach ($params as $key => $value) {
            $parameter = is_int($key) ? $key + 1 : $key;
            $type = match (true) {
                is_int($value)  => PDO::PARAM_INT,
                is_bool($value) => PDO::PARAM_BOOL,
                $value === null => PDO::PARAM_NULL,
                default         => PDO::PARAM_STR,
            };
            $statement->bindValue($parameter, $value, $type);
        }

        $statement->execute();

        return $statement;
    }

    /**
     * @param array<int|string, mixed> $params
     * @return array<string, mixed>|null
     */
    public static function one(string $sql, array $params = []): ?array
    {
        $row = self::query($sql, $params)->fetch();
        return is_array($row) ? $row : null;
    }

    /**
     * @param array<int|string, mixed> $params
     * @return list<array<string, mixed>>
     */
    public static function all(string $sql, array $params = []): array
    {
        $rows = self::query($sql, $params)->fetchAll();
        return is_array($rows) ? $rows : [];
    }

    /** @param array<int|string, mixed> $params */
    public static function value(string $sql, array $params = []): mixed
    {
        $value = self::query($sql, $params)->fetchColumn();
        return $value === false ? null : $value;
    }

    /** @param array<int|string, mixed> $params */
    public static function execute(string $sql, array $params = []): int
    {
        return self::query($sql, $params)->rowCount();
    }

    /**
     * Insert a row using a validated identifier and named placeholders.
     *
     * @param array<string, mixed> $data
     */
    public static function insert(string $table, array $data): int
    {
        self::assertIdentifier($table);

        $columns = array_keys($data);
        foreach ($columns as $column) {
            self::assertIdentifier($column);
        }

        $placeholders = array_map(static fn (string $column): string => ':' . $column, $columns);
        $sql = sprintf(
            'INSERT INTO `%s` (`%s`) VALUES (%s)',
            $table,
            implode('`, `', $columns),
            implode(', ', $placeholders)
        );

        self::query($sql, self::prefixKeys($data));

        return (int) self::pdo()->lastInsertId();
    }

    /**
     * Update a row using a validated identifier and named placeholders.
     *
     * @param array<string, mixed>  $data
     * @param array<string, mixed>  $where
     */
    public static function update(string $table, array $data, array $where): int
    {
        self::assertIdentifier($table);

        $set = [];
        foreach (array_keys($data) as $column) {
            self::assertIdentifier($column);
            $set[] = sprintf('`%s` = :set_%s', $column, $column);
        }

        $conditions = [];
        foreach (array_keys($where) as $column) {
            self::assertIdentifier($column);
            $conditions[] = sprintf('`%s` = :where_%s', $column, $column);
        }

        if ($set === [] || $conditions === []) {
            throw new RuntimeException('Update requires data and a where clause.');
        }

        $params = [];
        foreach ($data as $column => $value) {
            $params['set_' . $column] = $value;
        }
        foreach ($where as $column => $value) {
            $params['where_' . $column] = $value;
        }

        $sql = sprintf(
            'UPDATE `%s` SET %s WHERE %s',
            $table,
            implode(', ', $set),
            implode(' AND ', $conditions)
        );

        return self::execute($sql, $params);
    }

    /** @param array<string, mixed> $data @return array<string, mixed> */
    private static function prefixKeys(array $data): array
    {
        $prefixed = [];
        foreach ($data as $key => $value) {
            $prefixed[':' . $key] = $value;
        }
        return $prefixed;
    }

    private static function assertIdentifier(string $identifier): void
    {
        if (!preg_match('/^[A-Za-z_][A-Za-z0-9_]*$/', $identifier)) {
            throw new RuntimeException('Invalid database identifier.');
        }
    }
}
