use criterion::{black_box, criterion_group, criterion_main, Criterion};

use day04::{part1, part2};

fn criterion_benchmark(c: &mut Criterion) {
    let input = include_str!("../src/input.txt");
    c.bench_function("day4 part 1", |b| b.iter(|| part1::process(black_box(input))));
    c.bench_function("day4 part 2", |b| b.iter(|| part2::process(black_box(input))));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);

