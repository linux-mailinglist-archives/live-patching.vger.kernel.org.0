Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6094759400
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 13:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjGSLMu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 07:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGSLMt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 07:12:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68714189;
        Wed, 19 Jul 2023 04:12:47 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ILefci018388;
        Wed, 19 Jul 2023 11:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : message-id : content-type : mime-version;
 s=corp-2023-03-30; bh=OIk/DGYLdpYdkHsdo9wFL0MPplbVk//dzza7/rvtHng=;
 b=pkuYQvmlke3dQnEz9UtbbPOyLYPtS6hz7skAVFf8nOlEEBSg4uFCLpNNadD+Dd0YPTsm
 XgMHvIdvIZp7Yf6YvaF0O9dRGImB9OnuL4BzAyXzxXYRzbAb1umnOX4Y82wyZgpcPZRe
 PHhX8XD3YuphS+J7QunheG7PH6LGwtFaYWOB7Pa33mWSXkjKSJ+57INUsGP3w878j3jG
 ikPyraK77/jpVxMJ2UzxWl4ZcKE6rEKc4gjk6tjinf+ueQxUzchqEtmQ6LPsl/uaDKlY
 L0E01Zli5+3RMvGSxOLj4ghWZzhbSFjYYtycuJLfq3oDsa0+TkbVuJegz4LWabaAq7ik mQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run76y8us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 11:12:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36JACdX9000862;
        Wed, 19 Jul 2023 11:12:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw6nv5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 11:12:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL20JFcxbf9V+vsDTEF/qkUH144uxBJzjxGrXP36wNarVuRTzrZ063BlixcAJPoMC7zmJKybbfLuRpSJ7LixCdp+p3VT150qbj4a/xmhqzsk9lrY2oBHEGeR6PwU0O0VgjbcmUEkZ9mPCf32M7vFEVcunaU16gZQNKHO4yKGtxLAPRarUPtGjffcL6hoeTvREviTVdRR0rFdY/KUzaS34mxFR5lHU0bbFPxhzOCfHfyeZvMtBH4snPoa5eaoGjIuDTymMKazJc5LQ8gz0n5iaw/CwMLA+2c7OdWil0nM4LEgnl1mKIe1AlvT2jzdfykogCPItmDOf+04ONxKqiLyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIk/DGYLdpYdkHsdo9wFL0MPplbVk//dzza7/rvtHng=;
 b=Z82muS+PYl2hNs+MOLZys5lE1cOAysk1+CJDcaxuZlqorkOn9bNu5/FNjwiaHUwIVZrvOUakgkq88dOUa7rgf9R833TjByA6bbIGsA0oFhuJt+0C+xdDzn3J3exnYTpsZeIhatJlHyGlzmV6IE2ZvuE3jHSvGYDSInVGImxB28/VnOuUFh7B4M0GzLleg+R2OylNAyypXOJ23bnCpypOIlq+zF0xoPwOU+bx5XohY2X2y57iq/RiUPPhpAb6JXRRI8jHgQn1iTlt+yd3fYLhaqibXvb3tBZ+2hJTMdHz1qmu8Fiy9PTHz+Lp551ZU/9IdltduGODXDN0payylioUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIk/DGYLdpYdkHsdo9wFL0MPplbVk//dzza7/rvtHng=;
 b=fQbw6rok6aEirVGNyqjDOdElOqWs3kFDyJutb7sunNeVg2gGx0PjbFCljSqg15/4Rx2bXFGPR0QWIT7SjPSWc7qG7DjAgfr0hCe/frxLHr/VH87ffkwJpxHrlLFtlqDgyB2NxgAVvITFwDUtPjRy2f/wKcy4kIJHxzfDEDkTxxM=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by BLAPR10MB5155.namprd10.prod.outlook.com (2603:10b6:208:320::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 11:12:15 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d301:aff1:6e01:417d]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d301:aff1:6e01:417d%5]) with mapi id 15.20.6588.031; Wed, 19 Jul 2023
 11:12:14 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     Alessandro Carminati <alessandro.carminati@gmail.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Nick Alcock <nick.alcock@oracle.com>, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
References: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
 <20230714150326.1152359-1-alessandro.carminati@gmail.com>
 <20230717105240.3d986331@gandalf.local.home>
Emacs:  you'll understand when you're older, dear.
Date:   Wed, 19 Jul 2023 12:12:06 +0100
Message-ID: <874jm088ah.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|BLAPR10MB5155:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb8c7cb-7b08-4097-a094-08db88490144
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iesKORo/qoMCHPD86YGop+r7+C50bC1QKbG0wLI0sMbTjv1gRepVvoWu6fgBTOTDmqKC8UEVQk5YOmNY6EZExud7mBfDWHH+LX5x+4LDsb37uma7YSOiVSlziRTrnyTiKYot+Gmp+bQ/82NXq3dvW55GvU2Gh/d+4d0RU1z3sSiKWEhf7/PXieebTHP6miO0/flq88dMLXIyN9RQhLtf41nnE4qPOp3mV7b4h0PViPSVxyi/Zx7WHwQo8vyEoUJSuRxISICYdV2yW+9ltqgCvPfX6syGDnpUdL1acAm0l7gKqPc7O+cS7HeGtlHYkOntKfe5SJ1h5btG/3UNBZ4EGLHi08noBplXg4HY14FXQokOJA+N2nBQeb5f9JI1d/1WDdi9mcM1yY3j0/JlTgF25PQq6cnlycDXrYbg7T6BrxVwvbrkMKvdp4IMd3PxQ9AEaKx5eOUz/uxRXCkFf1KUV+3wE6EAIuPZDhsV3HCfVzeRxxYhyY1p7+v3grcEQD7KqMBEgGGyQGKEaipd0vkQVjj5Cc+XfpOjOliqwx4EH+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(38100700002)(2906002)(6512007)(6666004)(9686003)(966005)(6486002)(83380400001)(36756003)(186003)(6506007)(86362001)(6916009)(478600001)(4326008)(44832011)(41300700001)(8936002)(8676002)(54906003)(66556008)(7416002)(66476007)(316002)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XO+Azfdb0HZC89Ph6Lu1INywWWafJ16lHBsypksvimGsc7p3Lk4aVLkeeDag?=
 =?us-ascii?Q?u5K5SML6vR8+2H8BDQhCyGAFO7pzD+2aco+1AwYKD60uLPYkUGLpGlVhRiI9?=
 =?us-ascii?Q?jQiqN0Afvs/LFYhamJ1+X4ifKERUWSKJcQ6RzaoApb1eik6NsQ4ulJUYCnIR?=
 =?us-ascii?Q?gph+fDepTMnyjvw9a363Ia9jfGfBvIdcKmoJW/j2YEkq+I8f6YfbaMeuQI7u?=
 =?us-ascii?Q?ATAR2UhwVav7N43ECxzg1N7BfyRsPzdPeH4fDzMMOz/g8uL8qJgD8H8o59bg?=
 =?us-ascii?Q?0Byf8QrGk7c7meykTAHK83Z37/76ApjKi0oxeCCPGrMZyCilm4UZ9mTIS8K3?=
 =?us-ascii?Q?PB0nA318tf+TIOzy+cjXZr7WiwwBY7t+b8cUQaD9LnDeGnGaxk9VOXQAxkRu?=
 =?us-ascii?Q?OTsjNiNl35T9WjP3b16xNvvP7oMhpN5lqIPgF1rRAIWeR5Ig29R5dHe7Zxru?=
 =?us-ascii?Q?HWVIMLlIGPJRU7LnxbS9EwTgzAfoAfikdptFEfF1WuT3SM3rin8SY9RtehRJ?=
 =?us-ascii?Q?h7ptCBkroba3rZGXFZve4VVAaj7e7OvnH1JOMAeNO8nUoKMx2cTMZtTbF3XT?=
 =?us-ascii?Q?IOlk+8b/tBYCGcd5ACgC5LBy1M/vcZZRvHMX2TWd1f66MhIFJaShrYjW9cti?=
 =?us-ascii?Q?ek2h3hulox6CjuRsLnYn2o+UnMcYs6KlhSTCdJpTHxqP9ZbBl6mufZY/Cc9B?=
 =?us-ascii?Q?TnOhyZB6ONgF3+oYPtFofDl1hJA8X3UGA+c233LgjKA0CUEBz6ACsZR9UPze?=
 =?us-ascii?Q?vN/EoZhu6ebE1k1RGl6Hy+OUO2mBNipJelfPYOsE3DmTyQBCxjf2ju0woAb8?=
 =?us-ascii?Q?Mp2OPVD7yy2KCZaM/Cg4yfgE2gy0pzVYs5KDbWA4xloz4t8CMiqHU1v0YDci?=
 =?us-ascii?Q?7CauHtZeP0CHu2BNSNpawo4y3mDyvqYMmZM3YEX45zNDUCdutKJ06dkNHChG?=
 =?us-ascii?Q?6iMskDcXEbEqPm4cxYHQmWDiT9zV00flkH2r/dYFOabRosR2RZymelQHT1XL?=
 =?us-ascii?Q?7SgAHSbnAmcOemSEC88c5X5Q2M8gLTg5+mY/EKymG0cwrZekS1RRDCC/6/JO?=
 =?us-ascii?Q?SX8VzjqZsMKYmd0GjAgEINfxtYOvBxt6eiSWLsDhBRgGODrqnfMGXGBJAA6Q?=
 =?us-ascii?Q?uIfcwwIX16KlWgMI6hNHXnUwJCfh5iFXhle+R6yUEkGDKcsccfWPCLLixly3?=
 =?us-ascii?Q?wAmU8I9HznQg+aY2R1DSYGupWCTfvyQ3idCzW9B/7LLeruQZ+KnUALrZV9ew?=
 =?us-ascii?Q?v9dOzaO+Oicd2dZpkYK58h9lZvnMUjeYfhnf7RUMBVUaqbzyru51ELbMKk87?=
 =?us-ascii?Q?pbPI7eet/SeAKDsVtnQVWVLkDpOeCJu4fAcNFxb6nvm7dJTAGYvRfJiHWkWK?=
 =?us-ascii?Q?sGvLY+skEOlfbT+KDwXD7GHepsps/hU6+Fha9scebxdvq4m5dDS9u8tyAZdG?=
 =?us-ascii?Q?aa+E+esrPpKonDe7+zwmBpfuSJ/CxTVhYSnfvpz3RAWvaZfPRSskPprC3JSV?=
 =?us-ascii?Q?VvYQ/ejcbN16PkjUCTzkJWEWWoY0XwX+DALNlw895pkzGD1IqXMf8wfGrDGL?=
 =?us-ascii?Q?5pGLlgm9V7T/7b+G1l6H/d3B3B574lbrgHuj0iZJ6CFZ6KzBZDZyxIqkMvYP?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nH4uvOofh1nBwLDI2DUaY+3xkyv30/SyA7RPAbFrx+pc7R/liUEJUsUoOZUdK/KD5jUfSASPHXjO1n1eFL0kd912DUVlsJ+1PufsiVKwB47Awu5l9JDSZp70mps6nTy7W6bHj1i9WxFC1sj/FkDiKAGVSa9eL/y2KM1vr62IxVoH2328pOt51iR2Plieowax0h9YZe74YUnFRFLyMVz1II3gMnD/acg9C+WaZsj6T3vxY1P8nq3DyAzvTYB1PbyzzQoqcYp7+30NTnFUxnBY43J5CpD51LN/0SpocVZvz9KAizu9mg1aalCXK0GCFpKNcsw1bTdB8+tYwx26mKGbgbhhZ6mBSSElBvupb6k1NENkXG969jhuliI306HUhA2MJouSa4U/fM62YgnoEIaapgXtj89ubms9Uach8BxAeXsVLZ0XhCFCrtjYwFxzAthM9PvrnxYsaz93LNKXPDx6oib4V/WQyhpXEShxChKVBTdmULvzpwzt6dXlymmnFV2KwS9C4UGlQwd3PshqBoK8Nghoib3yTqBHFvxy32jQBVbZ1/C7aGNLfROMfz7JIgg4Zf4+SVIPHFLWXqI0TYlVc2RhdOXLjG+BqKpOzTffWnc1JgucYQfbEQGaVp/rymZv74qDea9p1QcokhCdFUCOjSjr7GmECw+uC6yIZOleO+8Z2YX4/0Z8xgf90wXjQCsAKrVEfZd4gOH5Ul0mBJlT5ZQspRnfSR01Z+mk2lH/6+0Eq2tY7BHFjbM9JRU9JaCuiCpeE/sdCc+CgAs0XP5bbmCkvprTtT2dleYdpuRZ3cHUzqUBNf2oQSdPKVO/uRCD/Cvt9vL0Hn6Co0N+rxlPKUnYYklaUI08nLLc4qWpvs3ANuKd/AMPcCRU0MjA+0f52nWItXgaQbtQPSWNpIr2cw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb8c7cb-7b08-4097-a094-08db88490144
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 11:12:14.4958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZ4GSodBI6WnD+3gw84g+Hrgi6wIbL+ZLFrp4Pu8XqbLhgUqC2VJyBCArDSxSUa4YWyOnGIQmAIRw2YuUTjrhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_06,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190100
X-Proofpoint-GUID: N0Vh6sryoC6_oOcCamM0rRlN_aJZWOn1
X-Proofpoint-ORIG-GUID: N0Vh6sryoC6_oOcCamM0rRlN_aJZWOn1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[Reply concocted by hand out of lore.kernel.org archives because this
 entire thread has seemingly been mis-sorted somewhere into the stygian
 blackness of my mail spool and I can't find it anywhere: apologies if I
 messed anything up]

On Mon, Jul 17, 2023 at 10:52:40AM -0400, Steven Rostedt wrote:
>> Honestly, I think the "_alias_<some-random-number>" is useless. It doesn't
>> give you any clue to what function you are actually attaching to. 
>
> Agreed.

Agreed, and not *only* because I have a patch series that I think does
better. I'm also a consumer of this stuff (that's why I wrote the patch)
and I'm afraid I couldn't do anything with a bunch of random numbers.
What user interface are we supposed to show people? All it tells you is
that two symbols are different, not which is which or where they come
from.

This seems to be useful for the one case of "look up a symbol out of a
trace log and then filter by it or re-trace using it": no other use case
seems possible, because a number is just so little information. I'm also
hoping that people can say *before they run a trace* "I know I'm looking
at a problem with cgroups, I want to look at blah@cgroup/cgroup.o"
without having to know beforehand that this is blah__alias_19404.

Actually, you probably *can* get something else out of plain numbers --
by looking at the aliased symbol name you got back, then looking at
/proc/kallmodsyms to see what other symbols it's textually close to,
guessing what object file they're in from their names and then grepping
around for what module that might be related to. i.e. doing by
eye-and-grep what my patch series is doing automatically.


A further problem: doing this using aliases in particular requires
modifying the tracers to ensure that they always report the aliased
symbol, not the non-aliased one at the same address. As it is, I suspect
a lot of them will either report whichever symbol comes first, or pick
one at random, or even try to disambiguate them themselves a second
time, leading to blah__alias_19404@something (double disambiguation) or
in some cases they'll simply hang. You might be lucky and see them pick
the longest aliased name, or whicheer one comes last, I suppose.

I think all the hanging tracers have been fixed in the last couple of
years but they certainly *used* to exist. This is of course a bug in
those tools, but it is easily overlookable when only a few symbols are
aliases: less so after this patch. Nonetheless, it is unarguable that
this series probably requires auditing (all?) kallsyms users, at least
to be sure they don't misbehave. (Mine doesn't need any of that, but
only because I'm using a new /proc file for that exact reason. People
migrating to it would also need adjustment.)

I know I've got too many concerns in one mail by now, but I'm *also* a
bit concerned about the space requirements of this: kallsyms's name
compression won't help compress all those textual numbers much. It's
certainly higher space requirements than my approach: it's just more
hidden because it's lumped into the existing kallsyms tables.


Alessandro: I'll have a look through your patch: after dumping on it
like this I think I have to. Alternate approaches are always worth
looking at :)

>> There's
>> been other approaches that show module and/or file names. I know there's
> > still some issues with getting those accepted, but I much rather have them
> > than this!
> > 
> > See: https://lore.kernel.org/all/20221205163157.269335-1-nick.alcock@oracle.com/
> 
> Yes, please coordinate with Nick and review each other's work, now we
> have two separate efforts with different reasons but hopefully we'll
> come back with one unified solution.

Yes indeed! I am getting back to this very soon (a few days), after a
prolonged hiatus getting USDT probing working in DTrace V2. Sorry about
that. (I suspect you wanted a break from my cover letters too!)

I think what my series really needs is someone capable of writing less
convoluted English, because my cover letter skills are still not
brilliant.

> Please Cc live-patching also, as they had suggested before just to
> provide the file filename + line number, that'll make it even more
> valuable.

That would be amazing! Nothing obvious occurs to me though.

My series could easily give objfile + address offset for every symbol
with little more overhead than we have now (we'd need to encode more
partial objfile names, that's all, low tens of KiB) -- the problem is
translating that address offset into a line number without a cripplingly
expensive storage-per-symbol lookup table. I mean if storing the size of
each symbol is too expensive (and it is, costing hundreds of KiB),
storing an offset->line number mapping probably would be too!

I'll think on it, maybe a trick to avoid representing every offset
individually will occur to me. (If any occurs to anyone else, I'd be
fascinated.)

-- 
NULL && (void)
