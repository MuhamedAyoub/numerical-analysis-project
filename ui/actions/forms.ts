import { SERVER_HOST } from '@/config/http';
import { TMatrix } from '../types/zod';
export const systemSolverApi = async (dt: TMatrix) => {
    try {

        const response = await fetch(`${SERVER_HOST}/ch2`, {
            body: JSON.stringify(dt),
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
        
        });
        return await response.json();
    }catch (e) {
        console.error(e);
        return null;
    }
};
