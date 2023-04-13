Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571796E13F2
	for <lists+live-patching@lfdr.de>; Thu, 13 Apr 2023 20:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDMSR2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Apr 2023 14:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMSR1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Apr 2023 14:17:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1401665A0;
        Thu, 13 Apr 2023 11:17:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DGUFOG015118;
        Thu, 13 Apr 2023 18:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=bzXKrLc9gG7HqhcsO8VqymdZiFFN249oUVHz4dG6D/k=;
 b=t9OqhsOijWOQZO5K8GQsAp0u9DpzveIO+88jfUU7AnZlBECpXnqi0TiLxCp0wZh39P83
 XP0B2VUbwqvGPQGsEssCM+SdabHFwL4HXBzvdDoHJDp1we5VWNimuSkDygNDM8ANIPbL
 dnWtrDYV5gsK2nQi5PBLxiAUqf4zGNs93apT3JvTBOXefv9kzezo6697ieNV0+kPSglJ
 FzJ/JbKfIkL+bM3uJC0ajba2Dm6b7xJvKUeZRcLuDvS0IERX37r2MSrxVEelwXc+Fwnb
 owj9o80QOOMhsYFp8jQRSV76QGrI02+DC98xtoB54MdCEFBVvuYjDuOfgNNSoeqa3jwX +Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0ttv1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 18:16:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33DH2hDi012591;
        Thu, 13 Apr 2023 18:16:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puweb692m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 18:15:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdIsL5hj5PFXLbLz1St5XfAiq9X1jHQIWA/yY6lbDb4cLC2EC24kgDGoY+wRqqcLVJ8+TTvDDowvl1RXCaXHT1OuF+lVS6fyDxIymAsCFmKAUUH05gCurqMFul3fW22JHrVtw3yR/lGynwXr3e+cmqSAJZWF0TWR/tBJTBLydypXKYxdX+jGrUVDaaWcyT3t8wBD9rWRhhjYkItg1sQbucceUiAyN1RZXc9tS4JL2ahznPcR+6yvUs80eHlIbMuoZHW4V8zvxXKwfh8g3Xz+d1twycAZgrrqmwYeeYC4sIPsDf7ssMIwfYXiJODzqCmajOW25AlkHmSWeJHU5QLrQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzXKrLc9gG7HqhcsO8VqymdZiFFN249oUVHz4dG6D/k=;
 b=JffDuofYbbraLVnVFCwR0r9O94yZxIFkVp2oQmch04xtjamD5IvVaGLl+9qRUDARgGLaSba3VHa/nc/qr64F7Wy9ZMRv7JuW7uXSuZXcsx7jle0A1mrdb0SyqFD1TIPR0Fhf3ro0Q0rMgU+FWLuMLeGLkgSdkwcBZ6V3R2z/EJ4wdR9BbvHM14fwJcwWeyAij7WJ+HbZh7CYKKhwkuOhb6x0OnYM1lFmqKG9QSGG+hijalPCqzkUNysF3ryRqjqoFst9sDLj0otApHyKATcTuk84Rf7zUzDHyknh98U2kWsVDEIkmaeeZXA513sy+Oww9CeIE87LmHv608/GARhJ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzXKrLc9gG7HqhcsO8VqymdZiFFN249oUVHz4dG6D/k=;
 b=gApeEwfg38mJzYOANgym260C4M0EXbKmsJqUgr2JSZjatIGZa+MO0h2hKRlPq0P948df3t4fBhYdXYtmhAHm8eV31W95RwHTJ6t8VNquAUUVL4sVi2QafbVKC6lxjQT9LUmeFC/p/a06lw+YCqdBa470e1w5ot05ywLna1YUp4E=
Received: from BYAPR10MB2888.namprd10.prod.outlook.com (2603:10b6:a03:88::32)
 by SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 13 Apr
 2023 18:15:57 +0000
Received: from BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::53da:d3b:d2e4:d40]) by BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::53da:d3b:d2e4:d40%6]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 18:15:56 +0000
From:   "Jose E. Marchesi" <jose.marchesi@oracle.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, madvenka@linux.microsoft.com,
        jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-toolchains@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic
 frame pointer validation
In-Reply-To: <ZDg2BUL4uauG/w4T@google.com> (Nick Desaulniers's message of
        "Thu, 13 Apr 2023 10:04:05 -0700")
References: <20230202074036.507249-1-madvenka@linux.microsoft.com>
        <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
        <ZDg2BUL4uauG/w4T@google.com>
Date:   Thu, 13 Apr 2023 20:15:50 +0200
Message-ID: <87wn2fhcmh.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::16) To BYAPR10MB2888.namprd10.prod.outlook.com
 (2603:10b6:a03:88::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2888:EE_|SJ0PR10MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfa5756-3abe-480e-e59f-08db3c4b204b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g7D9nxbnGX0wwGqIQzH5JscAzh/FM25nKsttjnDVMUgUpPNbTew6NtDGk/1uakF10/pGIRVdt4kVx0NRUIQfR4ZgWU9SOuY+47BkNa8kq7wYoDCkvsWnCnogFBFTQa1Aj8RuHS2mt9ZUhWi5aeHZ5+4AgNmqk3kVNj746W/vx27uJnB7hQ1Qno8UKw3qm4qPTP35vW3Jb0POMY92u0zE8ANchQQWyf0V1fQ5bSsz8syYQfCPqzXGEAH/rU5DfJehhYHNZuoIqK5jOQVXQLOAISzCZoH+c2ySspLIZjxrNB1/3fJjePSNlG7/LglbkUNSxz/Xy1tiYR66vddsXb+MbWAcXy6Ao24MpXnapGBfsbI9Z1QUbMAO98Bv9iX9rnU/IOxHU1Kg6Rhj0q3q+Uhk5NGsSsGrwQxFeC02hRhBz1SUHKU3KOBMfvA9/tcbo5X3a8pe/8GhfbQkByM8Kd0sUWiRrQgGl98KS27w7u+bNi3FpMpPZGBTLiihPtEn+7xvBbLuhs54BP5HDPfXay2hOkLY2ZEWxYGLsS88R/K81IOiOxl6g3Q41yP6bGlJJwETy3QCrdOsRMsLpvxSb1N6xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2888.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(83380400001)(66476007)(66556008)(41300700001)(8676002)(4326008)(66946007)(38100700002)(7416002)(8936002)(6916009)(316002)(5660300002)(478600001)(2616005)(36756003)(966005)(186003)(6486002)(2906002)(6512007)(6506007)(6666004)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yZABgABCf6AKfBtSp1/NySelSJeKEXvyLyvktiTf/MLD3au7NNChil6/oP0K?=
 =?us-ascii?Q?uTm5T17rbAvEg9kAIaVpbIGK210zRZy1w0kUhhZgmTaxtzS0RnqVKoq/HaXl?=
 =?us-ascii?Q?r0nOf+R1ShLRYXdzPHhDJFFnNJZg96n+l8Z55klTf/q/CmcYbu5fLi3YgwiW?=
 =?us-ascii?Q?G6Ljk0LGBqvUHCNjo3hyu5XeauEbbsS5byaBFwBL80G8/WrBpT8GgUQkSuVw?=
 =?us-ascii?Q?LZyaL2q3SQvUcf0kljszKK/1nwTw7NBI9y/TwMfVqJ+ZFqKRPXsf70bIhv9i?=
 =?us-ascii?Q?+wCmghD2I/8wCGtgl/EVaKHUclyc9pG9K1riWv3YCe9jhzRmVfzPOm0TCWnx?=
 =?us-ascii?Q?uTx8aRsY+UCr//vDdmtGnQQSUB0r9hxyQfuPGQAdPjdyQHTR3LEWfItV1ZOj?=
 =?us-ascii?Q?Pfu0/akujqwdRFcfmkMy1lKpaCVaij1jSNb9R9c93n1AHhA2uyX5ETXYanNt?=
 =?us-ascii?Q?ecDuxa5bshbH+nUIULYHgA5I6jQ+LwYfXWse+yzWMy0WX68NhumnsgfFS6kK?=
 =?us-ascii?Q?dsw6lZiA9iJeE+6MNTxrPYKgjTXskePgbAukPTZ6/DbCcyFrKWh3a6+LgDnN?=
 =?us-ascii?Q?6R4ZlNBUw4ZTNKKAdX/zVYbwJ5iTX/8Eboyp1w78Qm4T5DjKQw7AFLY4Ezkd?=
 =?us-ascii?Q?8aOndTjWh/JWEKjuYRPScB3NJMgq0SLg9ZGTc0w6a8iwoyu1YkOojdQEEiPo?=
 =?us-ascii?Q?ZsiXhj4v0aKSiz5q2J/MxOQAdostrjU9wq3niQRBDLI3m0kF2JdWrXItXkND?=
 =?us-ascii?Q?j7px3/r2A+N4Q0cygW7n773/AE/AoKdHCJkEq6F9z4lktMsQ1eYOzm3WKuWc?=
 =?us-ascii?Q?K9cyYGjVHgd3iUbMINbf3nfVDc2xREKZ1fwb1l1twPlTfy8utZ/ecYSCF0Rg?=
 =?us-ascii?Q?R9H0F041eVb9eZYqfJImH6HW3DdP1BajhvNZ80whQCrkvt0w9LGKcNMsxRVu?=
 =?us-ascii?Q?Sk9ropTZkynNqi3pYVYhXbbtud1tkX6fXsO0vQSFTa1S+F+wDiV4L5U5k1tK?=
 =?us-ascii?Q?3CgnZFQl+eC/aC6av1UAWZmQFf084h3yIL+CSOUUYUxowgSbg1TFtkfGffxL?=
 =?us-ascii?Q?JCJb8QMKvIjvmxhvncJB270MiUMBIpAWmwCGccpUNpR1fsza7iD4ifS4bZYF?=
 =?us-ascii?Q?7UqkaCIUW9SDw1lwzcGrDoBSGmBP245yPLrLKoQUGeDj84mxqaJJBFaDS8ei?=
 =?us-ascii?Q?U9IqOLfTRNzayVhsDoyxOoVLQaR4H1PpcI73cLt5aTbsLOnvsCbj4ODFX+Og?=
 =?us-ascii?Q?Vpd1pVcbGZ6cYmTaPXIIwgikltI0OjYvtbhpw2SA/1BKRvQYRjrRIpoN6x9w?=
 =?us-ascii?Q?wQal32Ezy5T9alLGHgHPgojezPP4TrhGmEAyNy76ivXi0ecFVqSJnvNkZL6Y?=
 =?us-ascii?Q?NiRyDDrrxQccgXl1AlyIqLAI9xNVNyijYAVC4HZ943zdVefdHpmRdD+ZDsi0?=
 =?us-ascii?Q?ON/zKqD7ZsHlaUuPiqooIZ6RqBF0qQYGHtEVrvMUmH0a6nC97Qoq1PafBtJI?=
 =?us-ascii?Q?crGJp74gDp8GjTfVmuhXL3JlpooOYywVvzffFsCylz4kQvNJPNDJx4+Goq+O?=
 =?us-ascii?Q?RpmV03YOQcfYEZvNnpRPRVzmf4uzwwGbUI1pigN29H/zfDxqot3dINJT2Wzc?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?izbJ1jOsElYy2rbgEXbxmmnRuH4rfmfFMeAg3m9TXBmAzEcII0QwHydPnp14?=
 =?us-ascii?Q?/hiyOCiv86dXRqqkyh3e3GcP9ftAJLOjvBMFciBi92rLXScleXTaj7zdAM82?=
 =?us-ascii?Q?qbxaSdFjs5X5/1jH0EbsUYH7J4cimxdd8AHEZkNINqzUotyA9BLQKl4dTWIl?=
 =?us-ascii?Q?7XZ/P902p4bqofvJE6kon97JG3XRrO98D8xTQjyFtn7yVgewDoadGDlbY2Bb?=
 =?us-ascii?Q?ws76aKzS6ez88GSjSZ9kggVH4I86TapAADDk1VVMJKV7cXHYm3oHNx2EoRT/?=
 =?us-ascii?Q?CS28iUAbsmxCaNxjHJnZPGXDH0WyrALYW8EzW+zghHJYXnhDjQDdWFa83qaB?=
 =?us-ascii?Q?18TJrkaYZaKHpCesWMiTAF7WgtInShJ6Q7BpwCI5vQQoFDytgtq7Jux/EI7A?=
 =?us-ascii?Q?qCF9qevGMyUAsrdjzEepB8nxhXNZ4E2aR6Zyr1hh7AGfNwOW9qMKSZlXnkvv?=
 =?us-ascii?Q?3LtD2CZAVb5Kl0p61lYraJ6sOT3rjNdPdGQ1ci8mY73/fDHL29k5LVSSML4P?=
 =?us-ascii?Q?58Vpd8YdlhOmspkU9jRyPZ4f+W1nHUnTDsdr1v5UWUGt+2Flf8b5+gBs9FSF?=
 =?us-ascii?Q?//BRt5biGl4kCOjKLlKMsrFdwkLDo3jtJQ50m8CnPFNXCUkNkPQoGHsjTahS?=
 =?us-ascii?Q?2qF95nYXGBDuWgYzV0dOC4LCNPUJupXvBac+Rhxoqvt9NOgBwIUmwgOHcx4Z?=
 =?us-ascii?Q?JaacHfDGBqQCvPC1u4VR/mAhg/h370LiEgh8jvgxlLEjibjJbad6RbGy9wpD?=
 =?us-ascii?Q?BJKOnxevh093qAiLTsIQECN0TjqrJKYSsgYzIhSmoNSb5QRh/2z/kgm3JMkw?=
 =?us-ascii?Q?RrjHB7/HxUWyMmwXwNaAiQH19PXp7xubn1HGsxYkRKBG/VGd4jjiJ3SR7mIY?=
 =?us-ascii?Q?UdraIcHYhYxntvR9If+i/cYy68aq6TwwWcuymVGwh2So7rtbYzIJaLcDYmo4?=
 =?us-ascii?Q?iEjOQrjAChE2IKz3thSvETriecKMDEZSZcfUac7LFpIcHI0uw5JcHb6byr1C?=
 =?us-ascii?Q?jYF9dSyWwveCKOOxMdWOXuXkK8K8htOwCPvWY8akV4OCqUo2Ev14qmk5bSUe?=
 =?us-ascii?Q?2O7LWOE3KoSjBNXrWrnWOkGORuaQpjggHQQrdcN0A2/ZnVJuc+cgGNPodpR9?=
 =?us-ascii?Q?78ysQvkjKRJ323aM0pgOp4G5dwPp2Is+xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfa5756-3abe-480e-e59f-08db3c4b204b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2888.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 18:15:56.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxn4thV67INQq3JR1ao1FJCaDnT/GW2Mi3QnTkbBrIS1Dc1WAYHt8NbQavAApOyUncNc+04whBnajhYvMmMjh6/6+t/dRI3P2Y634Wlf8o8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_12,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130162
X-Proofpoint-ORIG-GUID: YJsZT-CZ8jkf5ZrWrSi1ljmS8dk1aMAM
X-Proofpoint-GUID: YJsZT-CZ8jkf5ZrWrSi1ljmS8dk1aMAM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> On Thu, Mar 23, 2023 at 05:17:14PM +0000, Mark Rutland wrote:
>> Hi Madhavan,
>> 
>> At a high-level, I think this still falls afoul of our desire to not reverse
>> engineer control flow from the binary, and so I do not think this is the right
>> approach. I've expanded a bit on that below.
>> 
>> I do think it would be nice to have *some* of the objtool changes, as I do
>> think we will want to use objtool for some things in future (e.g. some
>> build-time binary patching such as table sorting).
>> 
>> > Problem
>> > =======
>> > 
>> > Objtool is complex and highly architecture-dependent. There are a lot of
>> > different checks in objtool that all of the code in the kernel must pass
>> > before livepatch can be enabled. If a check fails, it must be corrected
>> > before we can proceed. Sometimes, the kernel code needs to be fixed.
>> > Sometimes, it is a compiler bug that needs to be fixed. The challenge is
>> > also to prove that all the work is complete for an architecture.
>> > 
>> > As such, it presents a great challenge to enable livepatch for an
>> > architecture.
>> 
>> There's a more fundamental issue here in that objtool has to reverse-engineer
>> control flow, and so even if the kernel code and compiled code generation is
>> *perfect*, it's possible that objtool won't recognise the structure of the
>> generated code, and won't be able to reverse-engineer the correct control flow.
>> 
>> We've seen issues where objtool didn't understand jump tables, so support for
>> that got disabled on x86. A key objection from the arm64 side is that we don't
>> want to disable compile code generation strategies like this. Further, as
>> compiles evolve, their code generation strategies will change, and it's likely
>> there will be other cases that crop up. This is inherently fragile.
>> 
>> The key objections from the arm64 side is that we don't want to
>> reverse-engineer details from the binary, as this is complex, fragile, and
>> unstable. This is why we've previously suggested that we should work with
>> compiler folk to get what we need.
>
>> This still requires reverse-engineering the forward-edge control flow in order
>> to compute those offets, so the same objections apply with this approach. I do
>> not think this is the right approach.
>> 
>> I would *strongly* prefer that we work with compiler folk to get the
>> information that we need.
>
> IDK if it's relevant here, but I did see a commit go by to LLVM that
> seemed to include such info in a custom ELF section (for the purposes of
> improving fuzzing, IIUC). Maybe such an encoding scheme could be tested
> to see if it's reliable or usable?
> - https://github.com/llvm/llvm-project/commit/3e52c0926c22575d918e7ca8369522b986635cd3
> - https://clang.llvm.org/docs/SanitizerCoverage.html#tracing-control-flow
>
>> 
>> [...]
>> 
>> > 		FWIW, I have also compared the CFI I am generating with DWARF
>> > 		information that the compiler generates. The CFIs match a
>> > 		100% for Clang. In the case of gcc, the comparison fails
>> > 		in 1.7% of the cases. I have analyzed those cases and found
>> > 		the DWARF information generated by gcc is incorrect. The
>> > 		ORC generated by my Objtool is correct.
>> 
>> 
>> Have you reported this to the GCC folk, and can you give any examples?
>> I'm sure they would be interested in fixing this, regardless of whether we end
>> up using it.
>
> Yeah, at least a bug report is good. "See something, say something."

By all means, please.  If you guys report these issues on CFI
divergences in the GCC bugzilla, we will look into fixing them.

https://gcc.gnu.org/bugzilla
