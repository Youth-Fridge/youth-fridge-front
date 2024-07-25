import Foundation

// 입력을 읽어들입니다.
let input = Int(readLine()!)!

// 입력 값이 0보다 작으면 오류를 처리합니다.
guard input >= 0 else {
    fatalError("Input must be a non-negative integer.")
}

// 캐시 배열을 초기화합니다.
var cache = [Int](repeating: 0, count: input + 1)

// 기본값을 설정합니다.
if input >= 1 {
    cache[1] = 1
}

// 동적 계획법을 사용하여 Fibonacci 수열을 계산합니다.
for i in 2...input {
    cache[i] = cache[i - 1] + cache[i - 2]
}

// 결과를 출력합니다.
print(cache[input])
