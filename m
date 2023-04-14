Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D2E6E23B8
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 14:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDNMzl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 08:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDNMzk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 08:55:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024ADA276
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 05:55:11 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E5Pawt028835;
        Fri, 14 Apr 2023 12:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=kBIDcCIhAeOqBah5kXlf9WcNYXZQ79/T7EKGOVuek0Q=;
 b=sKneE4quO5YxRlV7RiZUitfpxcv2era1CXyY4/zFCQItIgcRhOWnMetOanzN05z1ejSM
 cQcC3P5YWCUGyO38wFTdfLEB62PZbFAM2CMETvKN4Xg3ZyGAdT4LO6PVJ4hsNwIZAtL+
 ZEgVHPt4i1Pro/U8lHgq4/9Z6Pf/Jj/r1mDVsZfp/E+3A3JZSg87b/d4VbjnYFwyWTaM
 UcamokuM+7TQVm4QTUmhGse8SVZhyyRfiMyGBaDA7vBA4hTLeUsHbT54VkL8o1WzfCZo
 9MueBclVqrOAT+zdhMmqVAIzVBDiWpNRJhh+u8t3oCWeO1jZISrd+zzkala5hvbZ4Z0O 3Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0ttx053-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 12:54:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EC9GIO011350;
        Fri, 14 Apr 2023 12:54:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw963pn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 12:54:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wki/8lmlynLSXQdspfClGeCc8PqTUKPjFNRmLlXUBcl1RzESUZZH6C6WdfPdeDL4SkPe4T5rYc+q+A5b8NJGIYBL7n9ln1UIwSFH6j1zsQi0uv1/lm65xBMxZS1XTG6X8DDe25e3Kda7bYv5ACLG4CJCTQi5/zDa+IE9w2tMHat57NPmOz9Rso0mW26iqUiPR/hKzM8SOlV+OqRypIA/UjRBDhHUiNsZbRi5vmr90MwSd3dNfz1C5rO7TEn763jWOLl63PQS1R7RM7RXrf8aZ3MSxiGl2uV6qjsS5M4IZJtBJBAwtd7uknq/PdeCqjBS5ZLCO1NMHotMrpFT7ApcgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBIDcCIhAeOqBah5kXlf9WcNYXZQ79/T7EKGOVuek0Q=;
 b=nIVco1zU4dPFmIfymzmmAwUuiQXtgyZphl4Ev/6LKs53QQt83fnRWI+Mnif5irZvTtl6cG7LFwvLEVOzNZsJ4SXybVeRgwviH6Fey3jmcOqwm971V4957UhU3duexAY26mmVxpptvhVxUxJvhJIOLyuqypMw+de65V/LpiEjRF/hpjX1bEf0mWFJp2hq6yXeiA9VuWBAwF+/97TYUpU1Nfk3nhnPyM3LXHNZbb7LGAkCjM3Zt/4wS4pM0xwqK4gQ5nmBSKb/VHzqHLL4s/LjtLXsehe7Lx5RFdyljpHRHUJpCzfVMvGtAwaytonLoP9roiMduNuorhtOxhmsuO7ivA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBIDcCIhAeOqBah5kXlf9WcNYXZQ79/T7EKGOVuek0Q=;
 b=lLxHiPkkJnpjZRe+fmzGUBpcfspfZpssZ+e8dwS7BRA/jFEv7xD7trTYTtVnRaa4ggd4J3Xdt+gv9VtxgEljTfdo8MmgnkyUs+LoaP6g2jggsJvVPGQoAQTqTSz9Zl1cGV15t9Vzy4lv8vSZmhghMy9JY2h9L6kSTAh2SY5m9iM=
Received: from BYAPR10MB2888.namprd10.prod.outlook.com (2603:10b6:a03:88::32)
 by PH0PR10MB6435.namprd10.prod.outlook.com (2603:10b6:510:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 12:54:44 +0000
Received: from BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::53da:d3b:d2e4:d40]) by BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::53da:d3b:d2e4:d40%6]) with mapi id 15.20.6277.038; Fri, 14 Apr 2023
 12:54:44 +0000
From:   "Jose E. Marchesi" <jose.marchesi@oracle.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        elena.zannoni@oracle.com, indu.bhagat@oracle.com
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> (Mark Rutland's message of "Fri,
        14 Apr 2023 10:53:03 +0100")
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
        <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
Date:   Fri, 14 Apr 2023 14:54:38 +0200
Message-ID: <87r0sm39pt.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::23) To BYAPR10MB2888.namprd10.prod.outlook.com
 (2603:10b6:a03:88::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2888:EE_|PH0PR10MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a264353-7d6f-4c54-c1ec-08db3ce76b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XswjFBF8kWGaZY15Y0r6G4vwT1ZDebcIixEq4D31kHgwrR/LdbMFgRhkqyeGCHTSQQQlSatTBE9L7nlsnCxX0tiDpZ0Pnm/s2phEjwthzxRPiybRbfYBB7EXyU/QCMaiHymuOu5iikqbHeAUEO2gnaMfKdiWS4ehyf/tvf2MBN865w5h2D8fQVjbHwCjGJFAawmWDloX8Tilf323jDIEbrmIUWac52WgCIKHQjVW1w10OVMdtymt/KIpN8HW4gyZUUg+arGPzdE3VGdToOae0IW10ZEfpPfTgUCPXIFqK+y40yeQKw4XOKxkicyQRogTGSw/fUXVCVc6Dap+RxksRsBQwhtIhW/D1+t+hTN7+nP9Ad2PaOmJizKklYkMtEBjpl9SQBjnfUAWiloK0K4lTcSocIawCptii+v6oCWRYUDPEpoQwcs+llmCaQTsf3hYeSLzm66cy5ltlIZNnO7CGHeYcJqc+tJJ6khHjTDW6vJOQjfFZQfrjVBOFXfDcDNi+MZpY+DaMA7UvZtrn5bSeYlAWt/bUUj/5oAIWxM6kEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2888.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199021)(66899021)(36756003)(478600001)(966005)(6486002)(6916009)(4326008)(66556008)(8676002)(66946007)(66476007)(41300700001)(316002)(54906003)(83380400001)(2616005)(107886003)(6666004)(186003)(6512007)(6506007)(86362001)(5660300002)(7416002)(38100700002)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iiujzHDlYhU6NS2mQclwfaLVdlyMNgDVI0gCA0QFCHS2iMg4NQk3M6uaityy?=
 =?us-ascii?Q?k8zL+DEHeRElRNxpNyyHxxRpTiP/WsIinGKiBoFowfke4/Vs0Iwx5CrBXCOH?=
 =?us-ascii?Q?1Il9BjKpVju+zOjVEpKI2Nj86ld7/zi403pS2N79q5Z6dFPaAKBDM5mbsy1j?=
 =?us-ascii?Q?GJ2uBV34EYzVroT9KWz22yrLFlhLE7h8LljI/+cg3+JDU7Xw3fKl/AjeLTpy?=
 =?us-ascii?Q?9UwU66CXD+hqgHuxGJw8ZE3uMzxUGE9lcZt94y5fiMBUO2IIF7unhZWMdJBF?=
 =?us-ascii?Q?/Z4X8uG/ra00qG54Xii+K9QfXuT6GlNhjATe0zJy5jKgd/v3HzBKf7Pjo992?=
 =?us-ascii?Q?wdy/2QBNhXvk6Ypu971D1cbetW6yIL7pkUoGtV0jTfo+49Btox+5R5UlqjPz?=
 =?us-ascii?Q?NjUK2GHri1PB+3PHHRdUYn2w13FbyfspY63OxPhf1itZrBdu/o2jqcV6XYiJ?=
 =?us-ascii?Q?OTQSKF1qj6gsvQy01VgeXLpUOXQ5dhACylfCewzL61C6ymsHUuTmRYnrWUr3?=
 =?us-ascii?Q?/9Yjw46AR8Jq3M+T5oeOKe9BwkOEzEHchmHEOQuzXXhlqoHDNTf6F6gSDgHl?=
 =?us-ascii?Q?6LjxBIFqJrtcjS4OyxVV+YhMUpi0u4F7sZO6DFs8oz7UVDoFFXdhFA39SwXi?=
 =?us-ascii?Q?hEyW3CiUG8mrwBT1ks3OmNW1fSxBfwXaRw9ALDflQS67zzNOq35UWAulSDug?=
 =?us-ascii?Q?XQjNUtVGho+hDZilo+uh65K1vyNsZ0bDfrgTIhRB/2QSgWSBLxg0YUpwgmKr?=
 =?us-ascii?Q?FzhPlN/OQkSHzJ3oU9KqEAfpDuv5Co16qPZ1TSfZvXZEDgkAGqtPwcQ8/YhJ?=
 =?us-ascii?Q?HbKRhQXMVzDHJSAqeWrsc+xvURVW5p5lnLdeGml3kwJ2sAY57AMr1/Jbt87T?=
 =?us-ascii?Q?/ipfbONimTpYD8zqslpmbjtIAgSpNe6cJnekRKnPsJxcBoHouschA0HlEYVS?=
 =?us-ascii?Q?rs06mniQtSGl22Tm8WY/QdAH4nTrCk7XUmYBzDvL66S3LdLntbzIv1mE+GMi?=
 =?us-ascii?Q?LObGopV/1RiSEFstyK1QGUhXulpc9LBbt0jg8BwcBLyLI6D7CpKlP/lpGzEV?=
 =?us-ascii?Q?/DtYzYWB26Xv5BllbcybgPgjBSWNb9+TdpHmtfbEzl0akZ5u+QHo0Dfy+f7P?=
 =?us-ascii?Q?6SMEovqW5t5lIqaTBGCb+gIKwfhLPzFUOZDDKWpUs4bXPNi3D3zjMsJhF2A0?=
 =?us-ascii?Q?pOq4WvgTwg3CKfnRgweSFnO1Pe8JmM37GN//Ugf2bt5w0z6AzJXikOYdeKSU?=
 =?us-ascii?Q?nZHdB+SRQhVYV0HljZkr2TCqdc0bQWgk49So32uTQ9fzCdO8+p+BijLcqxuV?=
 =?us-ascii?Q?L/LoWsLG7pftIvLtqFXemJdVwktQys3SKFA+K/k3yORqIpc6Szg/mUyqK+Bg?=
 =?us-ascii?Q?FeiLk7xc9SQFQ7AhSYELEDz3XQntlgk+OHrQOKWAU4NhsTX7kq3yMgyoe5yf?=
 =?us-ascii?Q?JW9rmZBekBlM97Q7SXn8Q8nIrFJMFFZBVu3twmc+BUezjD9qBC8YXZcGJleB?=
 =?us-ascii?Q?NEWPwI12NutGFNRK6K2zlLB8JmsVpaU/vrCCPdCrBubGHsbID4AzXOnpG2pY?=
 =?us-ascii?Q?chmP1oT0yKCyeD27pdvkMCTMEzx6QLGUUtzn0cAJFxkC1H4p5+4HQ5c8vrow?=
 =?us-ascii?Q?rOFwalFC8C5KIR0Ruwrhi5ewv6wrk4t12/tepEsSQUusJT9oJVE9lbLTNOxy?=
 =?us-ascii?Q?0+mnlA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?OnphgUJ5+triAo4DV3xB/5A00XOZniItZyFAtHP4Id9nSi/qZo86XG/G9Cm7?=
 =?us-ascii?Q?xKYj170E7T0puf0c1t9e5D1hnoYKfpcWt93+v0eJztNg/zFW/ULje9YRXFkH?=
 =?us-ascii?Q?RtlBVmv5Bg4270Yj6Fa//ddXMqWgHeNQh6UGNT9fy672v6k5GXkbbts6yoc1?=
 =?us-ascii?Q?b8bg5guQYSUOUR8m6R40Cx7Sx839xBftLAaPhxzIPdDNkkZ8ogicDI+S+JmA?=
 =?us-ascii?Q?iBxW4WI4Sqb1k1fIaufgJm1zSoskKPJOO2md6Iy06yEZp2tfGjS+W0iwFzsP?=
 =?us-ascii?Q?JfLkc3/o2IcznbK0xrAIbfTnHjZzRGrMfFbZsq4RfCU5t9R7oDukpP6Zw790?=
 =?us-ascii?Q?Hik5FzK6ZhLa8yGmgoEHD9n1EopXxpRBL2ZPXafepMW3YSbufJVE8jVQwEfm?=
 =?us-ascii?Q?FO1Ulb8YJIY9VPvjeHAEwF8x3tihvK/RtqrFwb7KM/g8LPjiMoq9/wz34iTy?=
 =?us-ascii?Q?9Di+UB/At896f6zHGwQQZnglGxffxEO9pDTR46pzamIro72PCExaV+zWPG8C?=
 =?us-ascii?Q?ELA3zagXAzb2YuLIWyYiMbsDGH2F0OVJQx+sPp5+Q26dVaXho8qn//KlbC/M?=
 =?us-ascii?Q?9GaoqktOWoH8hY8W9armpRC/Zz7W54NEFKG2kICLKllUcfvMpOU2JhzQ8PIb?=
 =?us-ascii?Q?6AfZFjwKL0ohxbtFZ1Nc8DwXlp72uPdGoBJasVN1BNDeubW5oxsabwLmzmVR?=
 =?us-ascii?Q?C5YyVGRXjsda4Wn0k/SEDvoAQOAqBQ4GZJQ0Dp3qSjlRyHw8No8PFUz2RPRU?=
 =?us-ascii?Q?fmRHkljR7SI22Fg1p3s49LuMdecMD/Wm/qw/t+4DEQUPt8C1QoJ4knDd4NDz?=
 =?us-ascii?Q?53zDZUbm1i6R1M6ZLUJYcDzuj09s6IQmudwZ9hSUrLmdTYyNEbamMUDQDex8?=
 =?us-ascii?Q?jFlf3NwsCSXxsNq7FIxErThL2DXyBajl0L/0Ebn8ddOnExTubVMgnAashXTW?=
 =?us-ascii?Q?ITQ6SEOpUBSO8omfgt5Szg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a264353-7d6f-4c54-c1ec-08db3ce76b4e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2888.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:54:44.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEz/kJeHLjXPA30sRkeSRvIMmH0trTljvpip2sEJMCoEqqBZ7wmZ2qWgMmBuinnhdKOVv6aKGWJzqMbp/tsCkivDdCY2EjCuJJD//lbfYEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6435
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_06,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=870 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140117
X-Proofpoint-ORIG-GUID: oPUwMVg2sMRMNP_xQSnGBzQspZqf-W_B
X-Proofpoint-GUID: oPUwMVg2sMRMNP_xQSnGBzQspZqf-W_B
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> On Wed, Mar 29, 2023 at 02:05:43PM +0200, Miroslav Benes wrote:
>> Hi,
>> 
>> we would like to organize Live Patching Microconference at Linux Plumbers 
>> 2023. The conference will take place in Richmond, VA, USA. 13-15 November. 
>> https://lpc.events/. The call for proposals has been opened so it is time 
>> to start the preparation on our side.
>> 
>> You can find the proposal below. Comments are welcome. The list of topics 
>> is open, so feel free to add more. I tried to add key people to discuss 
>> the topics, but the list is not exhaustive. I would like to submit the 
>> proposal soonish even though the deadline is on 1 June. I assume that we 
>> can update the topics later. My plan is to also organize a proper Call for 
>> Topics after the submission and advertise it also on LKML.
>> 
>> Last but not least it would be nice to have a co-runner of the show. Josh, 
>> Joe, any volunteer? :)
>> 
>> Thank you
>> Miroslav
>> 
>> 
>> Proposal
>> --------
>> The Live Patching microconference at Linux Plumbers 2023 aims to gather
>> stakeholders and interested parties to discuss proposed features and
>> outstanding issues in live patching.
>> 
>> Live patching is a critical tool for maintaining system uptime and
>> security by enabling fixes to be applied to running systems without the
>> need for a reboot. The development of the infrastructure is an ongoing
>> effort and while many problems have been resolved and features
>> implemented, there are still open questions, some with already submitted
>> patch sets, which need to be discussed.
>> 
>> Live Patching microconferences at the previous Linux Plumbers
>> conferences proved to be useful in this regard and helped us to find
>> final solutions or at least promising directions to push the development
>> forward. It includes for example a support for several architectures
>> (ppc64le and s390x were added after x86_64), a late module patching and
>> module dependencies and user space live patching.
>> 
>> Currently proposed topics follow. The list is open though and more will
>> be added during the regular Call for Topics.
>> 
>>   - klp-convert (as means to fix CET IBT limitations) and its 
>>     upstreamability
>>   - shadow variables, global state transition
>>   - kselftests and the future direction of development
>>   - arm64 live patching
>
> I'm happy to talk about the kernel-side of arm64 live patching; it'd be good to
> get in contact with anyone looking at the arm64 userspace side (e.g.
> klp-convert).
>
> I have some topics which overlap between live-patching and general toolchain
> bits and pieces, and I'm not sure if they'd be best suited here or in a
> toolchain track, e.g.
>
> * How to avoid/minimize the need to reverse-engineer control flow for things
>   like ORC generation.
>
>   On the arm64 side we're pretty averse to doing this to generate metadata for
>   unwinding (and we might not need to), but there are things objtool does today
>   that requires awareness of control-flow (e.g. forward-edge checks for noinstr
>   safety).
>
>   Hopefully without a flamewar about DWARF...
>
> * Better compiler support for noinstr and similar properties.
>
>   For example, noinstr functions are currently all noinline, and we can't
>   inline a noinstr function into a noinstr function, leading to a painful mix
>   of noinstr and __always_inline. Having a mechanism to allow noinstr code to
>   be inlined into other noinstr code would be nice.
>
>   Likewise, whether we could somehow get compile-time warnings about unintended
>   calls from instrumentable code from noinstr code.
>
> * How is this going to work with rust?
>
>   It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
>   live-patching are going to work with rust. We probably need to start looking
>   soon.
>
> I've Cc'd Nick, Jose, and Miguel, in case they have thoughts.

We have indeed submitted a proposal for a Toolchains MC for Plumbers.

I think the two first topics mentioned above (CFG in ELF and handling of
noinstr functions) would definitely fit well in the Toolchains MC.

As for Rust... we have the Rust GCC support and that would fit in the MC
as well.  We can surely invite some of the hackers working in the
front-end.  But maybe it would be better to have that discussion in a
Rust MC, if there is gonna be one (Miguel?).

For starters, I would make sure that the involved MCs (Live Patching,
Toolchains, and an eventual Rust MC) do not overlap in the schedule.
Then we could have these discussions in either microconferences.

>> 
>> Key people
>> 
>>   - Josh Poimboeuf <jpoimboe@kernel.org>
>>   - Jiri Kosina <jikos@kernel.org>
>>   - Miroslav Benes <mbenes@suse.cz>
>>   - Petr Mladek <pmladek@suse.com>
>>   - Joe Lawrence <joe.lawrence@redhat.com>
>>   - Nicolai Stange <nstange@suse.de>
>>   - Marcos Paulo de Souza <mpdesouza@suse.de>
>>   - Mark Rutland <mark.rutland@arm.com>
>>   - Mark Brown <broonie@kernel.org>
>> 
>> We encourage all attendees to actively participate in the
>> microconference by sharing their ideas, experiences, and insights.
>> 
