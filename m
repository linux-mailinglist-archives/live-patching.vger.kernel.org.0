Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC875AEFB
	for <lists+live-patching@lfdr.de>; Thu, 20 Jul 2023 15:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjGTNBW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 09:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjGTNBV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 09:01:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486B110D2;
        Thu, 20 Jul 2023 06:01:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36K94GGN032453;
        Thu, 20 Jul 2023 13:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=mSqTuZr1ONTscDvmcV4YoKIJ9qZJCYFEkfNTx9lEBRw=;
 b=jBh6oIPKz4y5R4CvKlp3G80aG+GJkJj2OsTSDXH4xP3swlTiyaCTRFiHudg5yD2Rjpsq
 b+gMOOZczAFvtlEs35yaRG+UeKbwieetgrR2MYGtdSXn1UScfWmFMLZvIAVXDnWJlIRp
 QGvUOoeLNrUBHkPL6V/E/tS27EVUwzgE/IQdkx9rwltpNVKI7OXjRj3Ajy94ijZdq+Yr
 yE1EmEa2NaPJTqkWBfsf2AlRonJW7lygSZGM5vK8HmuWASis+G+Mo2U3pqueKB/UlwrR
 msjbyHVwdXovQjqw3YC8eJijyqzIGPBOXis55MV+MW93oat2eTP5L3XsW+yoIHbDpJXz Qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a9q7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 13:01:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36KBQRF6038227;
        Thu, 20 Jul 2023 13:00:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw8ma58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 13:00:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1WhzPsfvXgRx4bO19a16BQyhR+a8OxRDkB1Cm6kXDUEA1uoxcWCN3DSuhnsws2vcGlK1IAqez+5B3LDSY5hlFjFHyxt6jgf7CoyzDczugEM24gcleBO4dA76j6anFRftuVxhMz7Ifyj1tTdMLDv+texfu+nTKOmb5NQltJ93DzsjdtJwYRUdpj5PUxPVZIhwokALJ9Qd2C47M8ReNF+vzZNeHhIW3aDudAmOqs//NiXqUeHC1BVvUbnmB3aSkGMZFhWj0Nr2LapoHasQp9pUdfGuAfdf0ns2oqyQdycwASG8noMkJLoeRVlDXJF2VF4f+Dk+uI9FQdNRmKnFN/J/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSqTuZr1ONTscDvmcV4YoKIJ9qZJCYFEkfNTx9lEBRw=;
 b=AxPxXFVfwbURZxi+XUNaxopwi3rF2JlJLMdMcd2RVXxNrH1aOng/VhIO7yWYDWdHdo6V4QF3mPNnQyLDlseDyLxhNiULDLKYPOLp/5bId4Pb0XCPcrC3qbLR+AvCahwHNi4WVPxUBGJ7QLPGMR8EXQ3A/+ivhS27w5PXegMFM5Z5Xba+oFt0i0Pt1AU1dZUVq91vkNu7/lf9LP4gDqKWX/nGjU6NKIfi512AT/hEw+DAGrhjvyHDaFJff0nKptDleeRXJDRK8AbL3x9ClwIOCT5doFdk7Km9MYjPu93h/1UHWJXSRLQ106n8P2CgIDmwnaGp2J8X2mODr+t1m0gInA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSqTuZr1ONTscDvmcV4YoKIJ9qZJCYFEkfNTx9lEBRw=;
 b=iX2lVNngUbvTvGJ6g/RiP1ZPIixGM+EAvgoSOfu1Iyd3DNwlUV16TAR5/Hsg9UjE5KOkSatvBCkh2PtJOEp8lkzLm6gSpztws9QfaQ1xj8YePTri/STdxJT9I02ChCixvJi38hPlCvkemN/sFtdKFUPs290J/Yr6jYUAAhSuWe8=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by SJ0PR10MB5767.namprd10.prod.outlook.com (2603:10b6:a03:3ef::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Thu, 20 Jul
 2023 13:00:54 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d301:aff1:6e01:417d]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d301:aff1:6e01:417d%5]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 13:00:54 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Alessandro Carminati <alessandro.carminati@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <eugene.loh@oracle.com>,
        <kris.van.hees@oracle.com>, <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
References: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
        <20230714150326.1152359-1-alessandro.carminati@gmail.com>
        <20230717105240.3d986331@gandalf.local.home>
        <874jm088ah.fsf@esperi.org.uk>
        <6edbfe7b-aec4-2b3c-2f85-42e418ab3d99@intel.com>
Emacs:  because extension languages should come with the editor built in.
Date:   Thu, 20 Jul 2023 14:00:46 +0100
In-Reply-To: <6edbfe7b-aec4-2b3c-2f85-42e418ab3d99@intel.com> (Alexander
        Lobakin's message of "Wed, 19 Jul 2023 17:12:33 +0200")
Message-ID: <87wmyu7n5t.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0450.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::23) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|SJ0PR10MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ec4dc5-14c7-4ef0-d5c7-08db892159c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXMMsjilORCnruVXS/bhqP1WcIvqEdzC6qQRQJJs5KIc2iOr9NpQMSfKtB3gY/bUq4YEUkzJANqfCBU/ThLDvw5l2jvC9g/cM9ILnh1HJwbXPkiP+PKC/3LfdVqtNPx0eMFGIjl+yywTkbJKlQTCf5dJ24YRwBHroXpx5FoL473xQOwPY7gidXxQwcwKzsRC9V5yTwNHs5W2N9zcsiLGx0ajo/EsouzFRe6FRvdIb71qCJdX4e+PF2jJdKl7S6b3RxzsRLfgquR/557Eb54s/xoxpDWFpfwHjz5TM1yGzROGBBhg/bQVA1ABZR8aKdi3M61Eta6faGPFHsrBFjNlT2cgnjPJYijrwe9mSY053hvqMflsWadqutN6rqq6wuYAyFgjOoEJmWeRWe2k/0kMGB0DtVlwN7gaFe8Al+v0usRxhzNOUDqlEU4VIEoEGk7uVMTA+m1eUf+M5p2BrodfdojztxgXW30UG0Zo/2kPfY/IDsDbupZsrEpqyKHMX9X+Ux6eD9oJVrFYE17eeBpYIe8PdTjUQSaNnICGty1Z1tGWXK+kGovdSVY5QnlObzap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(8936002)(2906002)(36756003)(44832011)(6666004)(186003)(83380400001)(6506007)(6512007)(9686003)(6486002)(5660300002)(54906003)(38100700002)(7416002)(478600001)(86362001)(8676002)(66556008)(316002)(6916009)(66476007)(66946007)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YTaVD0EhR0d1VRn/wwDYNUqlyfnAAQheIeEWIBg3cKlidxE98qUSLrEi1CvB?=
 =?us-ascii?Q?TVv7uFfXd3BkPXI5qTDq2uFWj+A2sdMlrXaE/6QFDc31Ddhd3sl1q7EbEtr5?=
 =?us-ascii?Q?QxUAlWsr3+UtEkiA+DXvMAmYosZCTlcOaaA8OBHK6VTu5m6sc85kc6TxYu6B?=
 =?us-ascii?Q?ILpcXx1ke0ulxvS7MGhc+tomu1Tw+l4h8R+pswgVVTLjEpWIRqgdOEg8m+BJ?=
 =?us-ascii?Q?RJU+t6GA1P8Wbwp1RYsZouLYbJmsqx1a48EBOci4QpXiQ3Da3oLUrlg2IbdI?=
 =?us-ascii?Q?+LfRmrXW2AS1ORM79IthWnt1i0D1iWPrf0Dk+3EW6gmzV3aKnZR9rVIp3zWh?=
 =?us-ascii?Q?CwInZp9vreL+V24bJ6oyHfkjzduiAs1Edgc2+/QgxDvWA0XcjKBkt+aMShIn?=
 =?us-ascii?Q?WYFlomuZ4nBkRQlTOrL9f1EnjuDH1dsYjrNv6cLmlMA6g2OmgFYAo/VRoRHX?=
 =?us-ascii?Q?H5oJitA7qoYE7inwBARyhtlst0bxIOhV1yDh91jiaJAQOnWzXyVz/sagHjwM?=
 =?us-ascii?Q?GQkgzif279OKaTqacGD/6ARuglli4fxJSy1b0TLOaC5+aKmPOTRBCAvyQgKw?=
 =?us-ascii?Q?x/wtCJ8O4WNKc9FXGTafYoPWexIx8eloaEqSb/77mQEuKsvZKmfhlrrGbuBZ?=
 =?us-ascii?Q?8ykZZ0hrUg83noxEstyypJ4atSCaQp8S9jt1LsbkWoJCDmZ7A3xH3eEWTTK5?=
 =?us-ascii?Q?JXifBoCVT8aL84cGRt49Kj78qzzGJSpZaoICQGqrU1qfMmbIayXF1cX242Mi?=
 =?us-ascii?Q?7POUK6kiJLbPI7KKS9DFamZCgIJ1enkJ7zb2DST1JKcQgmmngjyHVuB4InM5?=
 =?us-ascii?Q?UFZDFBUUE0UDOZ26EGKUU/iXN5FfB8698/OT9RRVKqm93Sc7J1uFjFIfwrfX?=
 =?us-ascii?Q?N3k9mCfxlEHKowz6ML2o8kZwioZzjiQAWCopGhkDMDKGv/AJjx7Z7nEHo9V8?=
 =?us-ascii?Q?24il9xKBjf/tp8VYznUR0MB3Gp2hCelfWA5nuP3b7ISWJiO7bakjy+kCKqbF?=
 =?us-ascii?Q?MOYC2gRZWpbfbHbY9+p2skx2uGMI+pynv7q2r6+tmpnexqzoIlafU35J260J?=
 =?us-ascii?Q?gLJM7FUFa9cNVUO5RraFjQEBIqW2l4ImxesPhGJd3PPviN6N2Vnkqsoype4d?=
 =?us-ascii?Q?OvJ0tG64w+qyPfFsX4C4lQUHQXUSDZRmGnVsbDrX5fYA467iMzbyshCAn68i?=
 =?us-ascii?Q?xO+psWBFU+JEBQSthMe0COovMxfmMGsAnjmCb/r+BmMqcwOBUerqxz69W6yz?=
 =?us-ascii?Q?ObesMq8SqReVGy9mqvt1ed0CcC0p9h43RAK7x3acZ2SrXYHLOcMparCovcyR?=
 =?us-ascii?Q?kEqyH5+frCN59Xb5nkDAhtPNW9xr9I8+PqCto8WZdbIoBqyvf0MbjsoC9vgx?=
 =?us-ascii?Q?Hcn+KttNqjouqAvhX/PcZO3CNCdwavvwNdHFPaBJzwVzOsGGjVDINZIWJGlM?=
 =?us-ascii?Q?uQC3St8CS2JG+jVjjbhgz89viQS3iJntHouS3Wtoodae9u5qkQ2ZT4rYSa+y?=
 =?us-ascii?Q?TbDd1Aiqb1tZ380gCctrFuihEviMC3irTcY7Z7cHE+rSIQe5r3vvt4zKu8Bc?=
 =?us-ascii?Q?mc/ATFLVVNzAIirRVoWNZ+WMJE6QeQjD6hY8Nr2/UEfg8TgGUIJrSP8XnoRo?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?3Jw6fZy5NSjdG1balrfXhv0c35I/4zRlo45IiYshXTWIrZMtzKUBXAEUKlpK?=
 =?us-ascii?Q?f2jzkHZMJE3tRBQOo+5mKcCLMlWztCYhw2k3Y6lK/LfW4TtdG/DdDRGo5GUE?=
 =?us-ascii?Q?/uSCB1AuGrGCHY340xdbYhSMLmv7M3BjX91QQ1JtLRQPdxoaSgUajURPgCts?=
 =?us-ascii?Q?c3VD1tw7KKoWQu+rpnbBj78qRlWEvxGlYJ3gPdfPSo2MFdKHEhYAXjZTIg0E?=
 =?us-ascii?Q?l+Qq3jk6PCplzeouaOyrzttiLjpiQ1jCBgR7uAoFK9jBknrzaGVowhjI78CR?=
 =?us-ascii?Q?8x/WoH+iHTC9z7Ymfopq6YZc01hXuIg2UkiBFYaCzqWadxkwfKVb4c2XlKxR?=
 =?us-ascii?Q?QeIwgvrgzvKnMNiKc69sVscc1Mj9C4Dbs3yEBlPi1w/MOD36CjA0uUw022hi?=
 =?us-ascii?Q?2t6gQUU/8s5eSdKGmaUA4ANa20F6Zkzvs7gSaE0NAugh8MhhnstoCz2GGOc6?=
 =?us-ascii?Q?u9fARxjNOSGk6jgmfHe7iYMfj/WNHYaPa++JLR4jEJPE3RFiQrcUJ7IJjOAY?=
 =?us-ascii?Q?7pyBijpwjHHnSqdfphVm5R+0oU1luDEa4FMIMDeYaHaXLbctGk0CWM1UpHfC?=
 =?us-ascii?Q?Jcr+WGNmwAMPAPlsrGRHJ8ZDZ6itcMWOvOmrSrzzQhBagrWyUf16F532nryA?=
 =?us-ascii?Q?f0CPlGUmcapB2y8B5eCiJEsNDugRBLpQQf5IO/jsIVKOCsFTSFLMvtMzYF1E?=
 =?us-ascii?Q?dsUsr5uZXGx18xnOu7+O0kcMHv+T1xCz7jHBMOBDSWbg4NXqtatwhK8fJW8B?=
 =?us-ascii?Q?RUqFYh6Ckwf2TM1Wh1PpyoY0Kaq01YCHbF1Jhb66YLleQ6llDzL4/CP+1xXx?=
 =?us-ascii?Q?bGuvGFD3Y4ZAB3B1ZMkrc8GxSEUnUEALfsmjIctlbJRGG6TzFGJCNuMI3Hlm?=
 =?us-ascii?Q?72AqAL8WmM/TwPWR4+tmN8g0kYWR6DoEC5y4csbaROqrCAc3XJNMLSZWUeM6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ec4dc5-14c7-4ef0-d5c7-08db892159c9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 13:00:54.1793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILZ7RxmU6lR+ziX//0RusUmLiIspHCTIgch3t4FFZMVOEXpG2Uuqnp8XSz4IiL9/wvcKmYfVmXRB8DOGRut1PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-20_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307200109
X-Proofpoint-ORIG-GUID: 1xmZyaoXs1i1-qQKlSWS_jku6kc1nWhR
X-Proofpoint-GUID: 1xmZyaoXs1i1-qQKlSWS_jku6kc1nWhR
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 19 Jul 2023, Alexander Lobakin verbalised:

> From: Nick Alcock <nick.alcock@oracle.com>
> Date: Wed, 19 Jul 2023 12:12:06 +0100
>>> Yes, please coordinate with Nick and review each other's work, now we
>>> have two separate efforts with different reasons but hopefully we'll
>
> Three efforts[0] :D Mine went unnoticed unfortunately, so I switched to
> other projects then.

It's odd, nobody seems to have noticed these until recently and now
suddenly people are crawling out of the woodwork wanting unique
addresses :) maybe the ambiguous ones are just getting commonplace
enough that they're biting people more often?

> My idea was to give relative path from the kernel root to the objfile,
> as we have a good bunch of non-unique "filename + symbol name" pairs.

I considered that, but unfortunately that has two problems to a raging
perfectionist like me:

 - the objfile probably won't exist except if you're actually doing
   kernel development, since kernel build trees are big enough that a
   lot of people delete them after building or ship kernels to other
   machines: if someone else built your kernel (overwhelmingly common
   among non-kernel-devs) the objfiles are sure to be absent. (But an
   option to not truncate the names when you know they won't be absent
   might be a good idea, though this pushes space requirements up by
   hundreds of kilobytes so it should probably be off by default.)

 - even giving a path to the kernel module on disk (much lower
   resolution and vulnerable to ambiguity again) is unreliable because
   there's absolutely no guarantee that any given process can see any of
   them: they might be in a different fs namespace or the modules might
   only be present in an initramfs (hell, I even know setups which
   *compile* the modules needed for rootfs mounting in the initramfs!
   Yes this is borderline insane, yes it happens). More commonly, they
   might be compressed using any of a number of compressors, changing
   the name, and the kernel has no idea which compressor might have been
   used (not unless you want it to go and look, and, well, wandering
   around over the fs hunting down .ko.* files from kernelspace to get
   their names right is *not* my idea of a good time! It's hard enough
   to get that right from userspace, honestly, even with kmod helping.)

   The most you could do would be to provide a key you could use with
   kmod to dig the real modules out from userspace. Partial names are as
   good as anything for that :)

So all the objfile names are, when it comes down to it, is names with no
intrinsic meaning: even if they're filenames of some kind, tools can't
rely on being able to access those files. (For my most common use case,
using a tracer on an enterprise-built production kernel, they'd almost
never be able to.)

So you might as well treat the objfile names as arbitrary string keys
that might be a memory-jogger for humans, which means you can chop
boring bits off them to save space :)
