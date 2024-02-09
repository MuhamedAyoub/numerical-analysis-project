import { SERVER_HOST } from '@/config/http';
import { TCh4Body, TMatrix } from '../types/zod';
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



export const imageCompressorApi = async (body:TCh4Body)=> {
    try {
        console.log("Sending request to server...");
        const response = await fetch(`${SERVER_HOST}/ch4`, {
            body:JSON.stringify(body),
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
}