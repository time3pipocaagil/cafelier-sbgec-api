/*
  Warnings:

  - The values [TODO] on the enum `InventoryStatusEnum` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `cretedAt` on the `Inventory` table. All the data in the column will be lost.
  - The `status` column on the `ProductBrand` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `pakageWeightGrams` on the `ProductVariety` table. All the data in the column will be lost.
  - You are about to alter the column `name` on the `Supplier` table. The data in that column could be lost. The data in that column will be cast from `VarChar` to `VarChar(255)`.
  - You are about to drop the `ProductOrigin` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[email]` on the table `Employee` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `isoAlpha2` to the `Country` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isoAlpha3` to the `Country` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Country` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tld` to the `Country` table without a default value. This is not possible if the table is not empty.
  - Added the required column `email` to the `Employee` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone1` to the `Employee` table without a default value. This is not possible if the table is not empty.
  - Added the required column `position` to the `Employee` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Employee` table without a default value. This is not possible if the table is not empty.
  - Added the required column `customerId` to the `Order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `totalAmount` to the `Order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productId` to the `OrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `quantity` to the `OrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `totalPrice` to the `OrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `unitPrice` to the `OrderItem` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `processingMethod` on the `Product` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `packageWeightGrams` to the `ProductVariety` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "BrandStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "CoffeeProcessingMethod" AS ENUM ('WASHED', 'NATURAL', 'HONEY', 'PULPED_NATURAL', 'WET_HULLED', 'ANAEROBIC', 'CARBONIC_MACERATION', 'EXPERIMENTAL');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CREDIT_CARD', 'DEBIT_CARD', 'PAYPAL', 'PIX', 'BOLETO');

-- AlterEnum
BEGIN;
CREATE TYPE "InventoryStatusEnum_new" AS ENUM ('ACTIVE', 'INACTIVE', 'LOW_STOCK', 'OUT_OF_STOCK', 'COMING_SOON', 'PAUSED', 'REGISTERED');
ALTER TABLE "Inventory" ALTER COLUMN "status" TYPE "InventoryStatusEnum_new" USING ("status"::text::"InventoryStatusEnum_new");
ALTER TYPE "InventoryStatusEnum" RENAME TO "InventoryStatusEnum_old";
ALTER TYPE "InventoryStatusEnum_new" RENAME TO "InventoryStatusEnum";
DROP TYPE "InventoryStatusEnum_old";
COMMIT;

-- AlterTable
ALTER TABLE "Country" ADD COLUMN     "isoAlpha2" VARCHAR(2) NOT NULL,
ADD COLUMN     "isoAlpha3" VARCHAR(3) NOT NULL,
ADD COLUMN     "name" VARCHAR(64) NOT NULL,
ADD COLUMN     "tld" VARCHAR(64) NOT NULL;

-- AlterTable
ALTER TABLE "Employee" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "hireDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "phone1" TEXT NOT NULL,
ADD COLUMN     "phone2" TEXT,
ADD COLUMN     "position" TEXT NOT NULL,
ADD COLUMN     "status" "EmployeeUserStatusEnum" NOT NULL DEFAULT 'ACTIVE',
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "firstName" SET DATA TYPE TEXT,
ALTER COLUMN "lastName" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "Inventory" DROP COLUMN "cretedAt",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN "status" SET DEFAULT 'REGISTERED';

-- AlterTable
ALTER TABLE "Order" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "customerId" TEXT NOT NULL,
ADD COLUMN     "status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
ADD COLUMN     "totalAmount" DECIMAL(65,30) NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "OrderItem" ADD COLUMN     "productId" TEXT NOT NULL,
ADD COLUMN     "quantity" INTEGER NOT NULL,
ADD COLUMN     "totalPrice" DECIMAL(65,30) NOT NULL,
ADD COLUMN     "unitPrice" DECIMAL(65,30) NOT NULL;

-- AlterTable
ALTER TABLE "Product" DROP COLUMN "processingMethod",
ADD COLUMN     "processingMethod" "CoffeeProcessingMethod" NOT NULL;

-- AlterTable
ALTER TABLE "ProductBrand" DROP COLUMN "status",
ADD COLUMN     "status" "BrandStatus" NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE "ProductVariety" DROP COLUMN "pakageWeightGrams",
ADD COLUMN     "packageWeightGrams" DECIMAL(65,30) NOT NULL;

-- AlterTable
ALTER TABLE "Supplier" ALTER COLUMN "name" SET DATA TYPE VARCHAR(255);

-- DropTable
DROP TABLE "ProductOrigin";

-- DropEnum
DROP TYPE "BrandStatusEnum";

-- DropEnum
DROP TYPE "ProcessingMethodEnum";

-- CreateTable
CREATE TABLE "Department" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeRole" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "departmentId" TEXT NOT NULL,

    CONSTRAINT "EmployeeRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "address" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cart" (
    "id" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CartItem" (
    "_id" TEXT NOT NULL,
    "cartId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "price" DECIMAL(65,30) NOT NULL,

    CONSTRAINT "CartItem_pkey" PRIMARY KEY ("_id")
);

-- CreateTable
CREATE TABLE "Checkout" (
    "id" TEXT NOT NULL,
    "orderId" TEXT NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "paidAt" TIMESTAMP(3),
    "method" "PaymentMethod" NOT NULL,

    CONSTRAINT "Checkout_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_EmployeeToDepartment" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_EmployeeToDepartment_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_EmployeeUserToRoles" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_EmployeeUserToRoles_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Department_name_key" ON "Department"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Customer_email_key" ON "Customer"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Cart_customerId_key" ON "Cart"("customerId");

-- CreateIndex
CREATE UNIQUE INDEX "Checkout_orderId_key" ON "Checkout"("orderId");

-- CreateIndex
CREATE INDEX "_EmployeeToDepartment_B_index" ON "_EmployeeToDepartment"("B");

-- CreateIndex
CREATE INDEX "_EmployeeUserToRoles_B_index" ON "_EmployeeUserToRoles"("B");

-- CreateIndex
CREATE UNIQUE INDEX "Employee_email_key" ON "Employee"("email");

-- AddForeignKey
ALTER TABLE "EmployeeRole" ADD CONSTRAINT "EmployeeRole_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVariety" ADD CONSTRAINT "ProductVariety_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVariety" ADD CONSTRAINT "ProductVariety_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVarietyImage" ADD CONSTRAINT "ProductVarietyImage_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVarietyImage" ADD CONSTRAINT "ProductVarietyImage_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cart" ADD CONSTRAINT "Cart_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CartItem" ADD CONSTRAINT "CartItem_cartId_fkey" FOREIGN KEY ("cartId") REFERENCES "Cart"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CartItem" ADD CONSTRAINT "CartItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Checkout" ADD CONSTRAINT "Checkout_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EmployeeToDepartment" ADD CONSTRAINT "_EmployeeToDepartment_A_fkey" FOREIGN KEY ("A") REFERENCES "Department"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EmployeeToDepartment" ADD CONSTRAINT "_EmployeeToDepartment_B_fkey" FOREIGN KEY ("B") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EmployeeUserToRoles" ADD CONSTRAINT "_EmployeeUserToRoles_A_fkey" FOREIGN KEY ("A") REFERENCES "EmployeeRole"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EmployeeUserToRoles" ADD CONSTRAINT "_EmployeeUserToRoles_B_fkey" FOREIGN KEY ("B") REFERENCES "EmployeeUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;
