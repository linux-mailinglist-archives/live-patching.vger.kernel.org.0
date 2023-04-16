Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECE6E3607
	for <lists+live-patching@lfdr.de>; Sun, 16 Apr 2023 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjDPIW0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 16 Apr 2023 04:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDPIWZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 16 Apr 2023 04:22:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C9A19B1;
        Sun, 16 Apr 2023 01:22:23 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33G37PXf002731;
        Sun, 16 Apr 2023 08:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Dm+i6DfWc4q2QhFIAo6Db0L8kOUkWsuDtqxWvjWflHo=;
 b=LyePGuTpKMsK8MPiIfOs4Lg796TYarpIeVXmDdFoC27/0QS6IaLoAgF88Q71wYb4btpj
 rbUX4tv8LkB42mVdxr53vDVGGW/6SyTLeK2TDT6tHYmcfgwnzSKj53EgSqsf5ToV9mZH
 K1gYRpC5ILsixDTOJKIhnJV4ueAorgqhT21N4ojXttpS2v7RrQmAv+VwdAkKuisVR0y0
 HLOdj1IGQ+nWRHUHyj91zcksSyBuL4TUdnqI0uBG81UAXRQx+coEZdv9+Xx8/ePDAaO5
 rOi8skZVgfjZ7pcBm3WaiJyaKHrHhKBF3BWRsFotRXRm0F30k0+lfgevCWBvCKVsLc9v AA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pykycs716-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Apr 2023 08:21:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33G3tIJ5017582;
        Sun, 16 Apr 2023 08:21:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc32uw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Apr 2023 08:21:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cf0BWHuOsnjz/OWMHc9K7q1KwJkGQr4QFHMeOpyFy0M6PmAFrKSquPBrz0dtPy75kaNy7WvSh74Jvqho61WBd3Ri4a0UMxZtLP0kywH3fK4vbZ06owrpuIuQFwDym1QMgJ/fFMXgsw0SkpkLcIzNpwrW1Hx6ENHnUHzb1IMTS5Gq70Fb14cOJq5/kvizJ9rzJn14G3Q1Ipmw9NuLSrqJuhJC3j0fkD/kbkQPBYSG1umt6onwUQvNXDdOnBHGP4FEfqAcubemB80JefyPlCqnCYDveGBUxjtuOBCBfdqJTLHYoSUQwHkmvcKVPRK9MhHgcKvB/h0gBEVv2Ngk2uCxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dm+i6DfWc4q2QhFIAo6Db0L8kOUkWsuDtqxWvjWflHo=;
 b=IX8ceZs6YQE6JoTp5/TGeT59w2gNwL0KDqnbU77v131lS67X795BktHMUOdC5ckAaYwajtpEC63q4Rpvb1XCrYGbG9pA7KbG0GL5PbEnyNFuBdeF81DzU1iNTxkx4KXYpVW8It6VSOFX6LECyNuGWskrDb1nn6B0qaDxUYgqlERyQM9/o5JaEnv5xDR1KAI9Q3Xqiqlw5SGwP8PqDDHiIBolN8UYShOS2Hki0Q4Uk6cT59+uwqYb9oZGIvYsuQ6ZIgUkCq/B5okfTnXmp1SR/JcgzQlyTwW05iOsbWAVP7YyJ9XZg6AeSHls6wVzwCNWe2+dkIkPJR3yiBOktiZ+ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dm+i6DfWc4q2QhFIAo6Db0L8kOUkWsuDtqxWvjWflHo=;
 b=p5HaZetZCNsG5qHV/qgNHxwOa+RPfwlhJRgxUhAi4ncN7p2a/pRnUfVw+Q67JoC21XyNvR2d3zY6aPPmGR4ufYSOqwlKyr5sb5ySDdQVmJngk0mqQD7f8RkTtgRIyR0Rwi/IMoS1mGves14oYsEE37knQxmTqsja3daQWGSCQ+k=
Received: from MWHPR1001MB2158.namprd10.prod.outlook.com
 (2603:10b6:301:2d::17) by MN2PR10MB4222.namprd10.prod.outlook.com
 (2603:10b6:208:198::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sun, 16 Apr
 2023 08:21:46 +0000
Received: from MWHPR1001MB2158.namprd10.prod.outlook.com
 ([fe80::ff1c:f1fb:8db9:22e2]) by MWHPR1001MB2158.namprd10.prod.outlook.com
 ([fe80::ff1c:f1fb:8db9:22e2%7]) with mapi id 15.20.6277.049; Sun, 16 Apr 2023
 08:21:46 +0000
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-toolchains@vger.kernel.org
References: <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N> <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
 <20230412155221.2l2mqsyothseymeq@treble>
 <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
 <20230413163035.ttar5uexrpldz3yl@treble>
From:   Indu Bhagat <indu.bhagat@oracle.com>
Message-ID: <35520c4e-b7e4-6d98-c094-f7fea73d755b@oracle.com>
Date:   Sun, 16 Apr 2023 01:21:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20230413163035.ttar5uexrpldz3yl@treble>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0328.namprd03.prod.outlook.com
 (2603:10b6:303:dd::33) To MWHPR1001MB2158.namprd10.prod.outlook.com
 (2603:10b6:301:2d::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2158:EE_|MN2PR10MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: a793dc09-d3fc-44bd-ea64-08db3e539df9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYAs+iuRkmkGPrj6zvV/8tEHKLltoRl6aCvISKxAar3/wV1yjMZQtIfgYnpyVobVw6XVg1VCCBnDlofLlEKk2OlYmcU+Ge7PiDQo+IuW55g+g/3303+dP3UPd6NlI3BkmHuz4GXRaX8oL7LjYDgzHMwMzaaTWfNpCh8Stz8xnw2yj0EBrOxGFnbkJ5Gq3UftphRcALSZJDv/H2lpcdJ4RH8T94hcEfSOop0kZOXITQP5bWz+YEPaV2rfLWYr05qFWWqxuc2FfIjMBN9jvzL3og2v+HukIQwYe9tkQj1gKNUdkLfv9cFYHFjtsp1yXahM3vKuYccngKAzV8PJQc9ZVeq1WFRvyHXAtF5bDOIJd3nnvPgVO2Prc/7j8WLnK+SEdBNG1dQUDiLOtie876hYHvfOVYJSTz+7nJbJ43Ld+16Ds/nvRYbSRg37auhHRw652h4Mlja6g/uvRlGp5SZYbMnxWWjLXDSXi6NLqgocYlLfRdV6wh+3gLdpEW5Q43VuR8HQ8rNiai1+szRORMvEFcShabpMwrg7dUL1Z0cT6TpbpFG/JtM6TjAIS1jnQ3XRTk/lh3Rsa4B+9TEjcR9nZwrluw8+KD5Y7GKfPa8NFbDtFxDrdr2oaHUCHZL3+UZJMkTHopDesiWcLN4efCO6Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2158.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199021)(31686004)(2906002)(44832011)(8676002)(38100700002)(7416002)(5660300002)(36756003)(8936002)(4326008)(41300700001)(66476007)(83380400001)(110136005)(316002)(86362001)(2616005)(53546011)(31696002)(6506007)(6512007)(6666004)(186003)(6486002)(478600001)(66556008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnZnbExWclQ3RmhNdC85bHdSWVA0ZThMdXd4aXRiTWl4WW9QZkVWeG93RHE3?=
 =?utf-8?B?d2pIMDExN0ZRZmhLeWEyZ29abWJIR1M0eTRvb1dXU2lwbTJ0NksxSTZOK3oy?=
 =?utf-8?B?dzZDV2FhQnBEUVp0R1JHdEp5YXhma2oxS3ppOUllc3R3NlhSV3gzTjY0RHhC?=
 =?utf-8?B?SFhyUzkvQWJLRnFCZGZDVFMrcG5ETlRqQVdERVVXTTZtTXYrQVNrZVNOVDJn?=
 =?utf-8?B?MnhwVURmRzhxUFBDcGhZcnlZc3IrUWlUNTZoV3FZall0SHBsc0VlNDUvc1ls?=
 =?utf-8?B?c0JVRDY1RzB2cVNyUjF2ejd2aHI1RmRSUGhJVGVpaXhRQWYxQW5YOVc5YXRC?=
 =?utf-8?B?UThpaHMvb0hJYjdFbTFReVlIam5NRXV6THA4VDVuSVoxK2h1VXZDVWhyVVpM?=
 =?utf-8?B?NldXSVE0WTBaSW5qM1lwQk1OZUIwMklPdE5jNWg0c2tFVThLT1laRWhrUTlw?=
 =?utf-8?B?Sm5rblo2dndlR2lROHFzSmVRWmlQY21aQS8zZjhKWFloMndWSENNMkdBZFg1?=
 =?utf-8?B?SWJUaGsyS0ZaamVoK21ZMWovRU4ycnhCN1FLZ25VRVpWTlpCdGl3ZlVMeWk0?=
 =?utf-8?B?T0tsVVhqZUlkSDhrRkZvSFRrTi8raUQxbzUrKzlnTzBtMGV3d0hqdVUzbXhK?=
 =?utf-8?B?M3Rnc2h5ZTBNUFF0Q2pEUzRTMmI1RDBKeitUN21TZjI5TlZpYWRuRGxxSERS?=
 =?utf-8?B?Z2l6dEJ4cUtlTjJPdWR5NEJWWVJINTRIbkZwY2orYk1kVkNwdk5yTDBvYVlr?=
 =?utf-8?B?WENXem1LN01BdTFDa3BoQ2E5alZPL2dXeVNGTWRERmFFNHVZL240bWtDU1Uv?=
 =?utf-8?B?V1dVZkVOZ0pCNExGVVpmcmRIZDlGTnRkS21ONEJYelRhTk5jajNac0VpeTZB?=
 =?utf-8?B?bVV3U2k5NTJ2N216OWYwMnlSRjl4eWg1cWVLWCtuU0k0UUVuR1lOSFFETks3?=
 =?utf-8?B?MVdiY0h3RlZ3enUrNENGakdkbTN2MmhQRVNRRExKWDBKTTAyUnlJRDgwKzRo?=
 =?utf-8?B?ODIyK0JGTXBxT0RxTzh2Mm54czQ4MUIwYmJOUXp1T2QrYzdjTDkrZXgvQlRH?=
 =?utf-8?B?em9UVWw0Q3RYZU1CdWxDcllWU0Rocm5TTUdxSnlwK2NKaDNPYXB1R1FWc2NN?=
 =?utf-8?B?K1hoZkZrQWg1WHNxUUxnVkF5WUZIK3k1VURoM1ErUVlZZmtmWmNlQkVrc3Bs?=
 =?utf-8?B?RTdqYUJneUFxMUFwUW9hMXhHRGVJZDlGclg0bHRVV08rQllyK0FDcDNrZERN?=
 =?utf-8?B?Yk41VUJhQUt6R1FXdVhnajVmTmVWMUQzc3l6N1FONndXR1JVcUZqSHkvd2J3?=
 =?utf-8?B?NjVwRHMxSlZPS0JQR0RQYysrejRFYmh3TUMrWE9kcHN2UmFBOG51ajVvWVFz?=
 =?utf-8?B?QngvRmdJZmRHV0dvaHQ0OUdmYVJSaUhveXpzZUhmRmhiNWZybENZVDZRTVN5?=
 =?utf-8?B?Q2VGK1hDWnI5a3JLVHVidVR6dDZQbUpqUGlsMThwdGhmazZET2RhL0dLNkxy?=
 =?utf-8?B?T0ZIa1h2R29hREpVcmZSQ3Ryb3Z6Vlh0Zm1mRmlMOWI4Z0RxaWFvSVQ0VFpS?=
 =?utf-8?B?UGkrTUhNdzUxRUg1K1dQN2ltVTZaQ05zZHZ4YXpGa0FueU1lc29sbnpZL2tp?=
 =?utf-8?B?NExWemtjSGkxWkwvSnUxS1ExRml3Y3FYYkdObWNhY29VMitDOXZxakV4U2tx?=
 =?utf-8?B?eWcwTUxJeHNrd2tLUEs4Yy9Wd1k3YmFhQ3RIbURXWGt1ZjhKRlU4YzRybTRm?=
 =?utf-8?B?d1c5YnVhRm04WWM5WCtSQmUzZEw4SWFLVmdURE1lQWFRYTQrQ1I3UmtaSWRi?=
 =?utf-8?B?WVphcUp0ZGJsMjAvdjFnNEN5VEVVM01ZL1RHM0pPMzhmYXdKOEVnazRSajBj?=
 =?utf-8?B?T3hsSjVOUmFMQW5RL2picmt1dW5mdnhOaEcvd2dnSmFjTSsyaGdsdVBmUm1R?=
 =?utf-8?B?MDNiWWZqb2VlbmFFSXZRNW4yTWpVM3pVUTdpU053N2JJOTlEeXVsQnRoLzhS?=
 =?utf-8?B?eU1xVUFIbktQNFpKYzc3NGFJTlhYZnZHbFBmOFNXOVk4UG5UNTdTdmpmdG90?=
 =?utf-8?B?OHdqdnF0STA1eGtLazNpekVOb1ZYa2NURHpOMGQ2T0N1anZBd0N1RG8wc0Uy?=
 =?utf-8?B?OVVkSFUvd0FxN2IrWUthMTVBNTVKcFpuQ3lsOERkT29QNDhVVDZsRk9vVVd2?=
 =?utf-8?Q?1TKVs1PQwO5YIgKgkYXo8Qk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aFNLYUNiR0FXZytzbzY1YU5YdG1ZWk1IY0pZeGRPTk9IVS9IYU93Tlhtb3k0?=
 =?utf-8?B?dmgvM2J1NWhaei9zMHZhN3ZldmZVVGlZVDlFWUVKNFVCcy82QVlDVGgvak0w?=
 =?utf-8?B?RTlDbFJ5cVBhMUV4Znl6Y2E0akI1OHlzRjlUM0wyQ2pVNGFYUU9aMnZkTXNw?=
 =?utf-8?B?dFZsKzgrbVBkR0MvVDkrQzBNYy80cDYyZ01CWFVvRUdJVkZXckRYOVlQazJF?=
 =?utf-8?B?TWJTMWpYeHJOS2RCTGlnejllZ3RsZ2lSSFJ4czc4UVRXMysycUxmMW42ZmJn?=
 =?utf-8?B?N3hVenNFWWJhbnpSR2RwVmRDQjY1SFVKelhLRTFiM2hBdUlad0c4MVc0MUNM?=
 =?utf-8?B?NG1UQmJlNGIxSWN2ME9ueE1KMm4xUUw4UHVQOEZQK3hDT2V3RkgyMHpQa0JU?=
 =?utf-8?B?NDBaWVJXejIzaGdVMDcvbEdzSGlwaVZ6UzlpNGpBZkN0UzVrRTZnTGpEMlpB?=
 =?utf-8?B?ZnJPTzNCMWgzZjRFNFJZd1dSU0xSMHVteXhYTVVIWWk4cU5VQXgzWm9tUy9Q?=
 =?utf-8?B?c2w5aDF1NTUzT3NNZ2FUZFhHWUprY0RzZDBWaVJvZm1BbEtFNXBCcHNXQzhz?=
 =?utf-8?B?L2hLRlNCOUdBRWhxdVdacU9jazY5L0p0eEwrVUcrSUlJZXhwUUJUemdDVkcw?=
 =?utf-8?B?N1pvdWJvbVFwMGFCUnhINkNsT2xGNmNIM1dUTjltRlZxT3paNVNYeVVMWmQr?=
 =?utf-8?B?dkUxRWdHZHpicUpsRCt4L0h6T0ExRXV0bHN0ZTJDTjRNU040Y0Q2UTAzM1NE?=
 =?utf-8?B?MjJxYU5rdVdwZG1MNzRrOCsxOEs3S2l1N3psQmdXa2N3OVJubHVTMTZQNDY3?=
 =?utf-8?B?a1F0K281QUQ0QjFHcFFTbkRpcUhBUnFjbDFONFJtSG5iWjNtaUN1NU9IZkVs?=
 =?utf-8?B?c3BDNU9FZ0VuZEk2RkxrNENWNDdFZEdvUUg2TkNuaHJHL2I0UGp3V1FZUHpK?=
 =?utf-8?B?QitQRFNpSDRtalo2RFFabEEzZVRqZFN6WGJaNlJFWjJIVUZTd3hYMkdRa0c2?=
 =?utf-8?B?enltK1pxZlY4dy9yWmNJWmVmek5Edm4rSU9rVEdoTnpEVEdWcGNxV28zbjYz?=
 =?utf-8?B?MThqY3JHUVRCUGQyRTZnOEg3bm00cVRUa2EwbENTV0F1aFRtdHpEZ0VuQkdT?=
 =?utf-8?B?UWVpcUVUMDcyZ3VxdEdVUG5WQ2tzclowZXFwaERYclQyK09iR3BWeFg1eis4?=
 =?utf-8?B?QWhZVXZaYTRuU0IvU0I2ZVN3ZzByV2pMbG1hc1BhOWlGeHk3UnZRYlpVMHdn?=
 =?utf-8?B?UmdhOTlpZ1dXL2VqZGV6T2JEUHdqWFVpUTFxQ1hyTk85em9KelVrb3BLcC90?=
 =?utf-8?B?SWs4YUZKejRpSDlOb3g2QzJkSFhneDJhdktXc21DMHEydXdzNnpCTE5SbjNO?=
 =?utf-8?B?VjZnNVNzVityaWRIaFl0WUJMbmNZOUFDeUQzV2pKOEx4UHRSdVZBellxSHZi?=
 =?utf-8?Q?MPpb3NYN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a793dc09-d3fc-44bd-ea64-08db3e539df9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2158.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2023 08:21:45.9809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DW0mIsIW8M87lK0h4w6Dv8sAwjLcTbVMMrpkNIPEo2vLFJpoUL98hdmkOrQ3KnE52gX5EaHQEZuuOaQhvouB6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-16_04,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304160075
X-Proofpoint-GUID: UgFF_k2yhbFkxC_Plx4kmyEr4PTBOjIy
X-Proofpoint-ORIG-GUID: UgFF_k2yhbFkxC_Plx4kmyEr4PTBOjIy
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/13/23 9:30 AM, Josh Poimboeuf wrote:
> On Thu, Apr 13, 2023 at 09:59:31AM -0500, Madhavan T. Venkataraman wrote:
>> On 4/12/23 10:52, Josh Poimboeuf wrote:
>>> On Wed, Apr 12, 2023 at 09:50:23AM -0500, Madhavan T. Venkataraman wrote:
>>>>>> I read through the SFrame spec file briefly. It looks like I can easily adapt my
>>>>>> version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
>>>>>> folks agree to properly support and maintain SFrame, then I could send the next version
>>>>>> of the patchset based on SFrame.
>>>>>>
>>>>>> But I kinda need a clear path forward before I implement anything. I request the arm64
>>>>>> folks to comment on the above approach. Would it be useful to initiate an email discussion
>>>>>> with the compiler folks on what they plan to do to support SFrame? Or, should this all
>>>>>> happen face to face in some forum like LPC?
>>>>>
>>>>> SFrame is basically a simplified version of DWARF unwind, using it as an
>>>>> input to objtool is going to have the same issues I mentioned below (and
>>>>> as was discussed with your v1).
>>>>>
>>>>
>>>> Yes. It is a much simplified version of DWARF. So, I am hoping that the compiler folks
>>>> can provide the feature with a reliability guarantee. DWARF is too complex.
>>>
>>> I don't see what the complexity (or lack thereof) of the unwinding data
>>> format has to do with it.  The unreliability comes from the underlying
>>> data source, not the formatting of the data.
>>>
>>
>> What I meant is - if SFrame is implemented by simply extracting unwind info from
>> DWARF data and placing it in a separate section (as it is probably implemented now),
>> then what you say is totally true. But if the compiler folks agree to make SFrame reliable,
>> then either they have to make DWARF reliable. Or, they have to implement SFrame as a
>> separate feature and make it reliable. The former is tough to do as DWARF has a lot of complexity.
>> The latter is a lot easier to do.

SFrame stack trace data is generated by the GNU assembler, by using the 
.cfi_* asm directives embedded by the compiler.  So, it is true that the 
source of EH_Frame info and SFrame stack trace data is the same.

That said, yes, if you see bugs/inconsistencies in SFrame/EH_Frame info, 
please file the issue(s).

> 
> [ adding linux-toolchains ]
> 
> I don't think ensuring reliability is an easy task, regardless of the
> complexity of the unwinding format.
> 
> Whether it's SFrame or DWARF/eh_frame, the question would be how to
> ensure it's always reliable for a compiler "power user" like the kernel
> which has many edge cases (including lots of inline asm which the
> compiler has no visibility to) and which uses unwinding for more than
> just debugging.
> 
> It would need some kind of black-box testing on a complex code base.
> (hint: kind of like what objtool already does today)
> 

