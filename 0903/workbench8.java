public class workbench8 {
	public static void main(String[] args) {
		int Y = 5;
		int X = (Y + 4) * 3;
		System.out.println(X);
	}
}


/*
iconst_5	-> 숫자 5를 stack에 넣음
istore_1	-> stack의 5를 변수 Y에 저장	
iload_1		-> Y의 값을 stack에 가져옴	
iconst_4	-> 숫자 4를 stack에 넣음	
iadd		-> Y + 4				
iconst_3	-> 숫자 3을 stack에 넣음
imul		-> (Y + 4) × 3
istore_2	-> 계산 결과를 X에 저장
*/