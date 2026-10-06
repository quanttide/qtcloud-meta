//! qtcloud-meta CLI 入口。参数解析在这一层，范畴分析的实现在库里。

use clap::{Parser, Subcommand};
use qtcloud_meta_cli::category::{between, within};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "qtcloud-meta", about = "量潮元数据 CLI")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// 范畴分析
    Category {
        #[command(subcommand)]
        sub: CategoryCommands,
    },
}

#[derive(Subcommand)]
enum CategoryCommands {
    /// 范畴内分析：装载 → 分析 → 返回
    Within {
        /// 范畴标识符
        category: String,
        /// 输出格式：md 或 json
        #[arg(long, default_value = "md")]
        format: String,
        /// 输出文件路径，缺省打印到 stdout
        #[arg(long)]
        out: Option<PathBuf>,
        /// 严格模式：任一公理失败即非零退出
        #[arg(long)]
        strict: bool,
    },
    /// 范畴间分析：选定 → 映射 → 冲突 → 缺失 → 结论
    Between {
        /// 源范畴标识符
        from: String,
        /// 目标范畴标识符
        to: String,
        /// 输出格式：md 或 json
        #[arg(long, default_value = "md")]
        format: String,
        /// 输出文件路径，缺省打印到 stdout
        #[arg(long)]
        out: Option<PathBuf>,
    },
}

fn main() -> std::process::ExitCode {
    let cli = Cli::parse();
    match cli.command {
        Commands::Category { sub } => match sub {
            CategoryCommands::Within {
                category,
                format,
                out,
                strict,
            } => {
                let options = within::Options {
                    format,
                    out,
                    strict,
                };
                finish(within::run(&category, &options))
            }
            CategoryCommands::Between {
                from,
                to,
                format,
                out,
            } => {
                let options = between::Options { format, out };
                finish(between::run(&from, &to, &options))
            }
        },
    }
}

/// 成功返回 0，失败打印错误返回 1。
fn finish(result: Result<(), String>) -> std::process::ExitCode {
    match result {
        Ok(()) => std::process::ExitCode::SUCCESS,
        Err(message) => {
            eprintln!("错误：{message}");
            std::process::ExitCode::FAILURE
        }
    }
}
