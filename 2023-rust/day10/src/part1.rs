pub fn process(input: &str) -> String {
    todo!()
}

enum Pipe {
    Vert,
    Horiz,
    CornerUL,
    CornerLL,
    CornerUR,
    CornerLR
}

struct InvalidPipe {}
impl Error for InvalidPipe {}

impl TryFrom<String> for Pipe {
    fn try_from(value: String) -> Result<Self, Self::Error> {
        match value {
            "|" => Ok(Pipe::Vert),
            "F" => Ok(Pipe::CornerUL),
            "7" => Ok(Pipe::CornerUR),
            "J" => Ok(Pipe::CornerLR),
            "-" => Ok(Pipe::Horiz),
            "L" => Ok(Pipe::CornerLL),
            _ => Err
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use indoc::indoc;

    #[test]
    fn test_sample_input() {
        let input = indoc!{".....
        .F-7.
        .|.|.
        .L-J.
        .....
        "};
        todo!();
    }
}
