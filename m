Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D8D6E25D9
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 16:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjDNOfT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 10:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjDNOew (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 10:34:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FBAB471
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 07:34:46 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EEU17R015552;
        Fri, 14 Apr 2023 14:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=kC/qIVTybI+qBCpRVHNp58afb0wYBH7tYgD5wvNadvQ=;
 b=RzjJoDc80oFpli3ZHa5ZMVVJ2ziiWzKLq2deo3vqEm3tuLcCvlbncAaC74igZIuM6JH+
 RapaicO31buAQ8s5x1KpP90zp7i5aT1oGieGu3Qe7HjkINkwUoK6dcE9JTG3+KgTqppB
 bYG3JfKsYr/Z/J94meqeCf9G8bNgqCys0Fvn4lIzCqJqZ76jXV7PhDezBENo+l7uDhy8
 Lb5zuB/iydQaX78wHq3T72NrvaoQ78GeEV6Yrs10qrBwcCirmZOKGCK5Z8603bVD+8Ac
 z5p1fUhcq/Q4bxvwyCB0dHyb6GBf8I20r7YSmtEP0t3mFFE1nR2V59MmnFIy8SCHYuoE vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bw6452-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 14:34:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EEP81Q020967;
        Fri, 14 Apr 2023 14:34:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pwwgsgyg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 14:34:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nonDcm1eY78Ygj6n83SjymItrT0nb468h5Hv6TpjiLOjjJlm/LiDqWTVwYDJiEJhAqaChltfKYXGeYcPD7UKp8K6BVllbH2AEOkB/oOtTJuQgS/5k8t1zZy7ZtaPt24YBYe472KMxcQ2DrVxlvy2D7qDmJisJCqLn8IzfYImUUo2i18brdGTuQA7WB8/qm7tl5kW/4m8U37EOOFm60BZyxs8hZc02JZlRgHXqrcXJA61e6bT+UxI4bZKZecM8O91NMXWoXyd2TCC+/1nf22dVm74FjJ5coZh5ULPeU9LVvTg7adB6zUhlUMjNwfR1REZgEPBhVgC+I+ZugDM5EjB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kC/qIVTybI+qBCpRVHNp58afb0wYBH7tYgD5wvNadvQ=;
 b=k16CFqCIZpbe11sc9Qe03dTfDQ9MCP36RRCYGniDADlYnCzvgSLzSe02pLN5jpmTyN2k7SQe3aL4JBe8pB5n3IDkq+fB+fl2HZcUWInML6InEXE3z8xY2m1vg3nH/ZEmYkK3VFMQLk2jCHVSHmsFP2DvoUCuDwCXwMBWnM2jHuJ4SdogBmjUDxJiQxzP4lYUnurFMwr8whIMutnS8zGbJmsFXWpprf8UxbgWXWU1XJ2XV2PhK3j9TxUBK1sOkRpukLa8OFP8Fxb2Ow9ret8pjyC/D73aSQ1JGQYn1s8uwtCl1wC6BnMcQtD/HBa0p+ETo6Hiy3uT196aUqV5g3RlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kC/qIVTybI+qBCpRVHNp58afb0wYBH7tYgD5wvNadvQ=;
 b=uvHcIex06SryEE1jSeoTTBoj9GpolDCXbK5LcAtWxyqIkzmtjkH+WePGWs/tYPfnVn2DxlsT/nX2f9bNFNwjdbPic85mKvG2yJJ2nl7IOQ0yBQRf980GxjgR89/6YgQXu5pl1jByduMiPzuWiGJNbrStqwVlhIq+zMUDDUsuGUo=
Received: from BYAPR10MB2888.namprd10.prod.outlook.com (2603:10b6:a03:88::32)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Fri, 14 Apr 2023 14:34:22 +0000
Received: from BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::53da:d3b:d2e4:d40]) by BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::53da:d3b:d2e4:d40%6]) with mapi id 15.20.6277.038; Fri, 14 Apr 2023
 14:34:22 +0000
From:   "Jose E. Marchesi" <jose.marchesi@oracle.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        elena.zannoni@oracle.com, indu.bhagat@oracle.com
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <CANiq72mk8-TZO59+oL2B6Xt8KyZNDBtyaP6TCNLVCdLASjJDnQ@mail.gmail.com>
        (Miguel Ojeda's message of "Fri, 14 Apr 2023 15:51:21 +0200")
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
        <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> <87r0sm39pt.fsf@oracle.com>
        <CANiq72mk8-TZO59+oL2B6Xt8KyZNDBtyaP6TCNLVCdLASjJDnQ@mail.gmail.com>
Date:   Fri, 14 Apr 2023 16:34:15 +0200
Message-ID: <87a5za353s.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM0PR10CA0116.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::33) To BYAPR10MB2888.namprd10.prod.outlook.com
 (2603:10b6:a03:88::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2888:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 05efe3d1-9aea-4dd9-3059-08db3cf5568d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ik3is1oJLsNWDbKCxUkT+ecqzBbvK+lf0K/cXVv2meqdBJjxYQQNyj1n6LsoB+vxUXmbJSVXJkb658aaeN/FR5q5OnM2XuNfrmHD/qpQ5dl94VsZTtVIhjXfR7Lyj0a6Xa6+CkOY6kKjyYqc9ogRKi5bmxT8QuDg0330x8l5V/PZ2IMNAPSdxOwCuaXMsYScnX9d+Z1yeL3p0D0dBYcsXmMZLHPag2qXXxzwBP4Nf3Y/sDUKQqR/kicu9VVZrb43ep1fxtJYdcnsNt9IugpR4ELYPoMnk52mcw/NGcpuTZmzYSNv/CYWLMgtLI5Wa8GrhCMXCz3qeFXRL/ERo6FsccnRjgl/ggI2By5r+1L05A40KY+uY88j0mbbORYHtOxoxpw3q0nmTrObeatQxLBosfxVGwHAMyNbsyWxvp94MC0sJ8h1Ks3ZOtWoyTmUxtaVOmLps591Qv2QH7JvaBqPlDmZmtU+8UMx95oI4XtEO49OJk+ako2J4+lJl5JfV/Oy36JcVGtIkIwI34m2v8hTaHKGoM92OTrLe0TboQ1uW434dI4nJZKlHBCojNDned65
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2888.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(6666004)(6486002)(5660300002)(66556008)(6916009)(66476007)(66946007)(36756003)(4326008)(2906002)(7416002)(86362001)(38100700002)(41300700001)(8676002)(8936002)(316002)(478600001)(54906003)(53546011)(6512007)(6506007)(26005)(2616005)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWFQRDYzUzRuMVQ4YmhkM2JVa2NjZ3BwZGt0UWJUcm9kKzc3ajF1TXFqV2Jk?=
 =?utf-8?B?N0xpSXFZM3oxRENTZTQxYnZWSjJHMWFpdGVEK2xBV0pPdmNTemdGWGg1V0dr?=
 =?utf-8?B?WmQyTmRSbTNwdXhLdDN4RE42N2x6RUtsNUtXMGJWRzQ0S3dza1YrODZwRUpv?=
 =?utf-8?B?SFliWkVlVlY2VkhzR3pTdElaM3doMjRQeTl1MUFkaFI0Z3BObU11aGxhc1c1?=
 =?utf-8?B?L2g4SHRMZHFHUk5YVWVoZXJHeVpMV09lNk5sM3JxQlZlblZLRm4wRkdBSWNV?=
 =?utf-8?B?anU2SFJ4NUNzOEhUYTFNRnk1ZlNOeFBGZ1JNMU1tbTRnVjdSMVZ6NGJ2Nkhv?=
 =?utf-8?B?aGZHcWcyZ3pFZ0VTMTVZVXNCZTNnRXhzSzFKREJ3am9XSFVBMHVOekhZVXV0?=
 =?utf-8?B?T0x1Q01ZM25hakVLQjdCN2JTY0ltR0tEb0pocVQyd2xoNW1HNXRZaG8yOGtC?=
 =?utf-8?B?T0tnNVBRRTVabHkvdFByek1DWnJibUVoWC84c0ZjazA4MEdqd01QcGtUVUlU?=
 =?utf-8?B?N2NNU0hKaVlrTWt4RVlJMGRJWWs0STdZU0pMbFYxOGtOdXYrd3ZUZ3dHNHNK?=
 =?utf-8?B?UEUyN3FRdFh4WGRmeGpjWEcrZkJ1a25ZQ2NkVnU1eGRMZ1hiRk1vNFFlNTB5?=
 =?utf-8?B?UW9GQnlvQlNLMGc4cHkvdXZPckhXRjVQU1hoSUxxanVCcldBTmo0d0xlcnZq?=
 =?utf-8?B?WHhBWGt0SSs1RVhsVnhOYjhFbUNwY25rYTVEZkdBYmVrSm55QXpURm80dUJm?=
 =?utf-8?B?VHRFNExlSmhZdG5pTERlTWZ2bjVIaUdydHBiQ0ZTUjk0TWFNSTIvTVg0dW1M?=
 =?utf-8?B?TjZlSUw1NE5kQTBsQUFFRTFqMUphNEVRbTN6dE5saUQ2Z0ZaRGpCOE8xd2xJ?=
 =?utf-8?B?TFNBdi9JZWpuVjVaMDBiSGxaTWFmMXdCdG1TSWZFSXlsN3NjbHBHc1dxQmJo?=
 =?utf-8?B?TWxOS01MMWlkTFp6RkFNMDZYbEVHeWEwYUVtNTc5TEJEd3BBdmo3VVBCd3d5?=
 =?utf-8?B?RytTZStab05ZT1RxS21lbEgyUXUyOW5QbzB5WkNVdGc1dmE0MlRHRHNjdTY4?=
 =?utf-8?B?YjZrOEF5V1hMcjA4V1MwcVNqRjlrVXcwSm9NdjVXajFIYmtsaUVxQ3JiKzlu?=
 =?utf-8?B?dXRTS2U5WEs1blBadmMrZ1BRaElWOTFFbjJJeWkwbkhJYlNxT2UrbVpUOVNm?=
 =?utf-8?B?Z29yUEp4VzJibk5IUWRJY2UzOGgvckwzWnFKR0pnUHVjVDBUQmMzZEU2Yjh4?=
 =?utf-8?B?MHZHZVJYcXlpejZiNXAyMmFZQlorV3dudUFrMUREQlI5cHVQV0hxQlV3Q293?=
 =?utf-8?B?cGUzMnZkVisvY25STzJ3RWN3YTExUlFIanNmdEdpSmdNZ0ljajlxU1c3Z0kz?=
 =?utf-8?B?NUQvdW5xbUZ0Qng2UnJ3dHBjdE43MHVVS0Nwb3R3VUJtbTZ2ekpzemtRaGp1?=
 =?utf-8?B?ZDBNYmZNdmYvWjd0N3JjcUw5TlRpeDJ1VHZTV05maWZqN0I0UDhjRy92V0dh?=
 =?utf-8?B?ejhIbU5qT1pOT3FUSXZ2aGZXL0l1ZEFvclJXZVFvQlhzWVR1WU5UUEJ3WElF?=
 =?utf-8?B?SmpGZ0NlR3lkNFNNUmNicWtOZHRuZFE1RitqbENsMG1SWk5YTm5uTHhOUWRI?=
 =?utf-8?B?Q2UwQ1pOZ1RZRzdjdjRka1lQZHFkVEY2NTlxWHRhbXdPa0ZqbG10VnZ6Tzk2?=
 =?utf-8?B?WmRRemd2dUhwY015ZjU2UlFwSkhaNVBNMVVXVTZHQXhycWsreUUvQTF5dWJV?=
 =?utf-8?B?dU4wQVR6N0RXTy9UWEdER3plQjRuMDNOOHhraThKbGV4NVBXdERkZElxcnRj?=
 =?utf-8?B?eVVqOGlmWko3MXMyT2VFRjhUdTJpQkFub2NoWjJqRHZmUXJHKzJtQ3lMNmFO?=
 =?utf-8?B?ZlBwM2RpMHBZTHNSaWIrMTBiU0NOR1UvRDFJbHRndmpWNWErT3Qva3hrdHhB?=
 =?utf-8?B?blc4VENsUkVKVnNQTUtRVm1KWnovbTNCV05Fd0k4VWJ5Y3ZQd1FCSHdqMmh3?=
 =?utf-8?B?cjZWTHhzWDhXdkJQdGtJZ3lhNUpGcWZMeE5iNG9mSElQam5qMEY0R2tWWGg5?=
 =?utf-8?B?aXNPUmlyR044OWNFZ2NKVzVmRTZ0VEVpNHoweFc1S1JORmdETlBpZ1gvRE8w?=
 =?utf-8?B?L1BmNWNVQUl2Q3k2NFIva0ZCSVZsVjVFc2UwdnRaaExnMnFGcEtVYndFVFQ1?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UnllTnVKcTUrcnZyUkgveGRsN1ZMQWdiSGlQMC9LMGtQL0dlMjV0WU1MY2ZJ?=
 =?utf-8?B?d05Fb3BKcU83VXNYT0ZPSldNeWNtOVZ1SWcxcDhzVWxLcDI3Y21INXdCZS9w?=
 =?utf-8?B?akFHOTdESldVejhJeVJ3N1d6NkZ2dnU3QXVRdmk5RE5TTm5sZ2FXQndGR0gy?=
 =?utf-8?B?enc0R0tLVmc5bFNML21acUFMRERrcFM3MWFGbHhqcm1UVTJsMnhzTW1uRlN6?=
 =?utf-8?B?TkFSZUFsZzBGNm11Q1lHd2FaT1daTnVuZDFEQUtRbkthZDFoeHowRUN6bjFw?=
 =?utf-8?B?dEM1NTY1b0crK2pKWm9KS3lKZ1FXRXJoVjRUUU5sZ1VsZ0tYRHBxRncxdUFN?=
 =?utf-8?B?R0t5MzMvWlgwcmNIOWlSSzIzRCtYT2lwY0F0TFM4a3JxMlR6clFGQzQvM1Y5?=
 =?utf-8?B?T0RCRTNBODlWTlB1a0VHT0lpR3RMWlVSNExkQmZVd0hpQVZ0OW5aVWlWQzB1?=
 =?utf-8?B?dzFFR20zKzdPaWM3eVR5bUN3QW50T0tBTXc1dG5rUlhndGdOV2hXYUcwMkk4?=
 =?utf-8?B?NVJ2TEpmZG11Q3AxQmhkK1RjUllxc1NOUTl0OVdSc09SMHJZbW5JcUw1bzRI?=
 =?utf-8?B?V3hVZ00rTzlaUjJqTEw5bzlCZko2dFRuNnA1VnRraXRGOTRiWHpEZk8rckxz?=
 =?utf-8?B?MlZIUWFwUVNSYmVPZktXTEdFa2xMcU4wSGJQR1ptRUJHWlc0RFhKOW5XU0Mz?=
 =?utf-8?B?T3VRdXgyczY5S0pzRlc2b2Zka1VSaktjTS9rZm11V1FvY29mZUhmaGFuQ3R3?=
 =?utf-8?B?TThhM0tYdnFrSUl1RzhrZ0ZyWEdncEJmMzkwTEpuWlRQajc4U2oxYU1KTkxM?=
 =?utf-8?B?MUZVVk1HUnh5UWdGcHlhN010YUdqRjF5V2MvcXVFT3J3bHNwVk9DVzVvVDV1?=
 =?utf-8?B?SXNlbThrRXZ6SHc2YVVQOUFiRzhzbWxubjVZVzkxaFpteDgzS3MyM3NERWtz?=
 =?utf-8?B?YTExdUZSRzJ3NDAyQzFOTVdaZzl0OW5odHByNkZUZUpaQ2xtcGR6Y21iR0tl?=
 =?utf-8?B?dEcvbE5yMGN6RGd0U3lXcW1vZkZ4MDNhR3M2WFVGM2hld0ZxMlpuZGxjcURr?=
 =?utf-8?B?dkhLcnFIS0tFZXVLSEtvS3hzZS9uT3NIcFpkTGJqU1JEcXBsVzhpeTJwbmt4?=
 =?utf-8?B?bCtQR1lCa1BJYk03aE45dmlKZGZCTWQ1M1pxMU9ZVWNFdExpSW5MUk9EOWNq?=
 =?utf-8?B?SU1QdlJFSEF3dnZydXJjQ0g5VzZTUzU3TWpmaTZaQlBDQ094QnRTeVdLY2ht?=
 =?utf-8?B?Y2xoaHpiZk0rZ3hxVnlSUDZXMmxwKzdFMC9VeC9NblcraGpJdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05efe3d1-9aea-4dd9-3059-08db3cf5568d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2888.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 14:34:22.3144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R23awjY6VMUq0ByRHDASVUIGJqq3tyhxuDC6FjLQjwFWVbWD+Twc+xqGOdWBma6zL0agZeDPz10lL/v7N7WmgY3zavPBsyYH0Grdp5/BVck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_08,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140128
X-Proofpoint-GUID: KNlr_q4x_ZAuGo8jVQ0DCR634pJa2jRI
X-Proofpoint-ORIG-GUID: KNlr_q4x_ZAuGo8jVQ0DCR634pJa2jRI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> On Fri, Apr 14, 2023 at 2:54=E2=80=AFPM Jose E. Marchesi
> <jose.marchesi@oracle.com> wrote:
>>
>> As for Rust... we have the Rust GCC support and that would fit in the MC
>> as well.  We can surely invite some of the hackers working in the
>> front-end.  But maybe it would be better to have that discussion in a
>> Rust MC, if there is gonna be one (Miguel?).
>
> It is likely we will submit a Rust MC proposal, yeah.
>
> Last year we had both Rust GCC and rustc_codegen_gcc presenting in the
> Rust MC (and Kangrejos too), and I would be grateful to have them
> again, but if it is best for everybody otherwise, we can change things
> of course.

I think it makes sense to discuss these toolchain-related topics in the
Rust MC.  Infrastructure tends to be traversal :)

> (Is it already known how tight timing will be this year for MCs?)
>
>> For starters, I would make sure that the involved MCs (Live Patching,
>> Toolchains, and an eventual Rust MC) do not overlap in the schedule.
>> Then we could have these discussions in either microconferences.
>
> Yeah, it sounds good to me.
>
> Cheers,
> Miguel
