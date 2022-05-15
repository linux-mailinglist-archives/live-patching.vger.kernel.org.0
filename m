Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E405052FDDF
	for <lists+live-patching@lfdr.de>; Sat, 21 May 2022 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiEUPiT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 21 May 2022 11:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiEUPiS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 21 May 2022 11:38:18 -0400
X-Greylist: delayed 1137 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 May 2022 08:38:09 PDT
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02hn2239.outbound.protection.partner.outlook.cn [139.219.17.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE2362CD2
        for <live-patching@vger.kernel.org>; Sat, 21 May 2022 08:38:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8i90+kxxQ2KSSUE/QWnmAlVhD6w6RHw+RaLd1fHVjioCnKKN+slDxnwtR6plTlraNPMG0yvzmHj/39MABM6nwYJNXnSZeTh6GlnS4E8RyrfxFgdnZYM9F4wScl918OJlqfcuWPtoAvBFNODdrpzztPmPpsoJqmjy68E4WcegN7/uZSMpz2mYopYOXdllxPMtOzoyb6wPChJQpOtnYxVCFFJy52c1XSkyeZVyi2ZOSc7HwUtLLlNQhVZTYKbviVELzQriAkL3dtVfTGDsyIlyZIaGtF3hAqzPsRBxhn7yJOB6ou5GX3HEgliolcvnVGowBs34OsaSqWtEazedvaCCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3z5uhVUtqN5OyplYkKXQ17d4OAmlRJ8nVcEl3nfclrI=;
 b=aRk/KWE42Qh1XPkpxw+W1kCwpAMOMcAadOxJk2LMxKV5nzKxraMpkrEXZ+dtsWIxw74mGavI29x/qhIOmYtWeucX3R8F97xtGNKOyBuX+mZ4xld16tVKhOnEELHHTYTCE/8M5tIV1a6KR7gS3vL7NGrlXALmd9IZpokoPXs4EPwEUyMF5D/MGau35JRzMjpbgMrGyXZRepM594XoQkaCHnLBVR8DmF9Cm+1r87shlETy41QfEDNE9RlPaDmcvoOedNitwoysxJr3FO+Jdr2btMgGW9pWUTazgzMk0lLevdLqjO40d8wgCIBeMK3Nd3gA1dU8ASAkfre3FxWeqCdH0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gientech.com; dmarc=pass action=none header.from=gientech.com;
 dkim=pass header.d=gientech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gientech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3z5uhVUtqN5OyplYkKXQ17d4OAmlRJ8nVcEl3nfclrI=;
 b=bi71BeDVOvZFmeOHofMTt1iwrbLJw2CGjdSz9MoYBBJvcI+fxJri5bpO7q+swIGdZUAM95m9jBbJiR4Gi91IERF7zozerawmK6Bg06usidVkKOLHkBSbNGR7W6kB9K5rYfMKQ2I2MdpUKyKvnnlD6+mRIaXijLsRj30jYfbI0rNde2c6JhKDInLhuuXMU8865RUWI4gdH0IvIudnkTfB+LeiAAf0LavGem8PG26/1qnCp2ZAW+vQixArFPyFs4PAfgffxQzUG9q1ER7E1utbcYL0K7m4W7YRq8zfeKZX2zkhZ8wnpSa4XGbcw385eyNpFPsb271YO0omiSA5iTDv5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gientech.com;
Received: from SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn (10.43.106.85) by
 SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn (10.43.106.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.16; Sat, 21 May 2022 15:03:01 +0000
Received: from SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn ([10.43.106.85])
 by SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn ([10.43.106.85]) with mapi
 id 15.20.5273.019; Sat, 21 May 2022 15:03:01 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: RE..
To:     Recipients <tianjiao.yang@gientech.com>
From:   "J Wu" <tianjiao.yang@gientech.com>
Date:   Sun, 15 May 2022 12:15:44 +0000
Reply-To: contact@jimmywu.online
X-ClientProxiedBy: BJXPR01CA0051.CHNPR01.prod.partner.outlook.cn (10.43.33.18)
 To SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn (10.43.106.85)
Message-ID: <SH0PR01MB0729F3E952C2C527715BEC638ACC9@SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 325fca86-1232-4c18-3be8-08da366cb035
X-MS-TrafficTypeDiagnostic: SH0PR01MB0730:EE_
X-Microsoft-Antispam-PRVS: <SH0PR01MB0730D4180D752D8F5758882A8AD29@SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?5F2TMxm0nXPDNhajmgLIYhSx4pezLg6PoduMYzr7mLF56/NqcZTs/XSC8U?=
 =?iso-8859-1?Q?Wr8XCMKwbo2jGEyzHzAZDhN3Rw5b/viUd9mlTDAIYAvUmimw96uWhc9zZz?=
 =?iso-8859-1?Q?xJS0ua18cJVqNshWFD0dV2T2RCZwRG9hg8POCL48abIXESwb9crvMIKRbh?=
 =?iso-8859-1?Q?HXI+LGTDQRkwkJCUAOCkA1y1l8tAc4kQuN0xw1bVZCGDkO3v0CbmyQumvp?=
 =?iso-8859-1?Q?mSIFvE5GeM+PLziINbqASVbbE5V2XTsis33RfC+2FQ5kcOFK7UpR9jxMmP?=
 =?iso-8859-1?Q?tvqaVY+Sxj1P23Yy+vMIMPT1hEWaNUcfsHO/+5jvSByHajd0FxpH4ykUd1?=
 =?iso-8859-1?Q?ey0t/amGFh79E8kIRGFnxKj9xJRnQty14f91qeSPITq6Or9jSnXQHrt0Yk?=
 =?iso-8859-1?Q?1KfPZOTOOr5i9xGGACfruN8qACk8xYR5BIfiq2hCGwPL9MOln08TpEYbMa?=
 =?iso-8859-1?Q?aG6rAPnyuJizx32BlsvZmjApUlqZ8EaZPkWZJbiNwE2a9CvYP1Qd/YUh7v?=
 =?iso-8859-1?Q?oNe/gkxqmvlYOFQtyOCVeEPfjns5dH1NnqMr1cmfHHagoBBpGhMQ8sTnk6?=
 =?iso-8859-1?Q?O11Ocf8fBgZxwVnscQ8jV09ZR/e7PZpCvbe6YiYRjepjhNepTyA70Y96Fn?=
 =?iso-8859-1?Q?DgVuS50jK3Vx0zB71+OW5Qe/fudHxrEY56BVvFKwvUxiJMXBeQwbPeEp4Q?=
 =?iso-8859-1?Q?weuM6WQ4pNH5Yd3027h6mg2xNQhnUmWEuhV4vPo/wwdlfKLwHHVmlOcmuW?=
 =?iso-8859-1?Q?aNID+CJsRVCts6VjKDcF3PhKOIawNsRr2SLuY0wSz1YOKQdXWm2vgn4E4X?=
 =?iso-8859-1?Q?6xazL4XBla/D0nAUtqnG/FzaWUQJRkNmHJKm3u8Q1PbP+XbmebIg8PXA+2?=
 =?iso-8859-1?Q?oVCebdY/nY/63CTpPDp0+i7Rjg1Hz+7WSossJYz9XLCCXaHJEO/cfIsfeN?=
 =?iso-8859-1?Q?Bd1uXE2kPpGcwSW41wVyFaneOFULTj7vEIsNcqCOm8eM60C9wryrPm5bM9?=
 =?iso-8859-1?Q?2WL/YKQQG7g1XACwAtaxEF6fOet6WVVvQCRqGXvLx6SmlY1TWz/l4NIoRc?=
 =?iso-8859-1?Q?bQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:OSPM;SFS:(13230001)(366004)(558084003)(33656002)(40180700001)(6200100001)(55016003)(508600001)(38350700002)(38100700002)(40160700002)(7116003)(66946007)(66556008)(8676002)(6862004)(86362001)(26005)(7366002)(7406005)(7416002)(66476007)(4270600006)(9686003)(2906002)(7696005)(6666004)(52116002)(3480700007)(186003)(19618925003)(8936002)(62346012);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ASfxwVPBH+KFaCGTYpg1rTQp/ey/E6rQdKdCPorochKO4Vcq4R/BEnz5Og?=
 =?iso-8859-1?Q?Rdkalrp8QdsSm6zZWeooDj0Mrw92XQri7YYLYApBzTngUve4+AkF/7wTru?=
 =?iso-8859-1?Q?Mfk+p0akcUbwB8PuA8hNKxXPzPkK/DoITAhPxy7L8+15qcqaBSCqkQ6Hl7?=
 =?iso-8859-1?Q?z2MIJFEtD3MiSnC2NvsOUB6YIZcdtkxQCtE4PSIopYbWiuSI2uo7RbaPy3?=
 =?iso-8859-1?Q?KD8JBXuRnhBKPeonemhLPXEJqlDi+970oGEAerRCOJ6SEhpSZ1YSEO0nIO?=
 =?iso-8859-1?Q?jfDk4o6f8JoczsP1IU4wdg18aRzGSpWxudqSTSP9uYEpozecPbKN6Tc2wI?=
 =?iso-8859-1?Q?Yg88xughQQDk9/KE2ydl1d07fVYp1y0uf8JoWyEUaFBRag7KSS3aLbO9uL?=
 =?iso-8859-1?Q?zx3bJnA5BlnHMyqi+JfiXCbQ11yiijL0BUZAL+J2D4fj2xMpSRVORh9JYp?=
 =?iso-8859-1?Q?dH7tvDypXfLmWV7AFVpGKYTdeI0ukPC+AirAtePqxy7rtcvFagfYFO0WG1?=
 =?iso-8859-1?Q?1UZ0ZfMA3exPSRLT7h33SxnydaNixGu/NcZNMoF7V2WMnZidHcaKIr1Zhb?=
 =?iso-8859-1?Q?IuKLRrCkzeBNBsBl0QEofJAPxXzNzrCo116jV1LgkzeY5Aqcts/x0+wum8?=
 =?iso-8859-1?Q?Gfrozhg0n1nEoWmNbpKM0eNvKTojajbbgLrAZm5JFHhYEQqDcLyp7mF8Cw?=
 =?iso-8859-1?Q?y2ksrW2+EB1V+YhN7YxotgHGELxSLOmY8Klvd+w2toY1Aswc0dcAmXHsBB?=
 =?iso-8859-1?Q?Y3+G9j99Zmj4UjVmY0keYp216bPNhAvXBDG8RWDylO21x79L45FUN3IiBa?=
 =?iso-8859-1?Q?Zc6JnEosVcuaZHN2nBRKYGgRJJ+5ISiPAlA5L0l5irkSkChLm82+0Vh3o3?=
 =?iso-8859-1?Q?Cbez/hMOupm2NBmN0eGt5dlRzRQD3f4128XnlZUCgaenEkF2XOZMy2PfD5?=
 =?iso-8859-1?Q?bCllI5D0BX6iQgWO1iMJx7tWIOll7ZdOSJ1tdw7VW5FBGJv//JR2XuD6nD?=
 =?iso-8859-1?Q?NBfIp2kQBb2l2LJO2sAesdzzXZ7XuyQPfo10gXMPPGpivbu0IlQqwtewYy?=
 =?iso-8859-1?Q?UEiLH/dnlcSeqPZEEIU0Scscff6uuidoPyTNy0/bF2OSxFRnzL4KaBfIA4?=
 =?iso-8859-1?Q?VUxQX4u1NRoMwFPWBoqVewZbQsEUBK7w/7IOI7PFTGlhKVjik7ytqt0OIt?=
 =?iso-8859-1?Q?tm+3zkJ8ccKOggGfuEP/0iVq8tE4qc80/8MfKOKWcohfHWGOzE5492sV1S?=
 =?iso-8859-1?Q?d2AG3bqAzapMboYKeAQNKbIKujRuSFpsFs+OnK4lOF89wzEPLPBW8cSAto?=
 =?iso-8859-1?Q?0hopNXWFg9RM/RDaH4KR/bMhizb79+9TV/VILyWMtQ92CtIczANp4cCqWW?=
 =?iso-8859-1?Q?hotIEKZck5uysAFT3zx5EzfD9sWrOrdM7KEXCUK/Hps9C7AyjhdkrMKS0j?=
 =?iso-8859-1?Q?kL2j1iHd3pDUYkAQyIZsl/cUYLOtoxf930FC0kijED9HORmb/b1Ldn98B7?=
 =?iso-8859-1?Q?aNVbFN4g7j+i54iXhOXZIEHnFospTDjTt3tWBkliYlkCKPeBjPqBlvF9GO?=
 =?iso-8859-1?Q?tBZUKLULt8eGfDfHvNO1OGMqOj5l0B3Mgdigd2/RvCgj/1TouGAgMKEEsB?=
 =?iso-8859-1?Q?iQ5jBT1rC9sZrKfo5/ZKcnFlWC70T14Yh0+QRMhYcypeTBubaXikKdXnrL?=
 =?iso-8859-1?Q?DCrciMzSHHoqrNnOuNORs76iYKZnH/Vfw02KQeC7s0UhwTS4bG6PXSvSlO?=
 =?iso-8859-1?Q?Mp1iVOlFQ2pSJcNzKKIFKWL8U=3D?=
X-OriginatorOrg: gientech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325fca86-1232-4c18-3be8-08da366cb035
X-MS-Exchange-CrossTenant-AuthSource: SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2022 12:16:06.8243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 89592e53-6f9d-4b93-82b1-9f8da689f1b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3N8YzgaNJY1NgHLaUmIG9AsvkqRL/h0+XK3W86SMV5T+Db2Z8iKsvpGgBfNJ7oj8PIw+IpmJlpsl5EpRG+uVrOmDX8R440F44zkrMpMkiPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0730
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DATE_IN_PAST_96_XX,
        DKIM_INVALID,DKIM_SIGNED,NIXSPAM_IXHASH,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4894]
        *  3.0 NIXSPAM_IXHASH http://www.nixspam.org/
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  3.4 DATE_IN_PAST_96_XX Date: is 96 hours or more before Received:
        *      date
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Can we do this together
