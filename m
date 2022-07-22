Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3410057E62F
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 20:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiGVSCJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 14:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiGVSCI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 14:02:08 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736FB13F93;
        Fri, 22 Jul 2022 11:02:08 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26MGZWT4020412;
        Fri, 22 Jul 2022 11:02:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=T3r/cywyk7EuhTyBDNrQkinSl1ho7N0oeUPdhjPie1Q=;
 b=AWY6cdUY1YeBSj9+eU/DH65TTLYvY3dUTl+cx9UEIuzHHm6tJB4vXr141t8iNQrnuufv
 TMJouMcym8VKwO8e5j5GdSGTjpoZSZYHgGwsIuzngc2ChxxUb5HDh5ixVgJLHJxuwO3I
 ih46um++rPsYkvsth1unVwWo64AUUKuw97E= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hfyj38j5f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 11:02:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRZRDcA5DxViki41cWUBn56dGOhyC5ueUq2L0e0ciZ9mJxV8Lj1dFObGe+X6lHeQLL9xE1z762GfyXKbRRiIBgCRVaCa1oi9SPBTZHzM9vd2VK3P+Ri41F9XOnpLGmn+rEcGwSIArGKnu2xnKM2H7queRumrG3Txax7L3xf6pZAUz7bghXZspuQ8rff6ODx9c47c8EGf/jH77UeV1cT7vL/WSgRsmXMUdfOzOgUZSpwJcDtIf2MfJfuzL2E42X+2XRomKtJBlOc89blmpmgVppCyGjQuB0zPDtKw+cBYozDK0gYYNN6k2nLTsZ4f4rcHyLmdI9kpLaOTM4JiUPPY+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3r/cywyk7EuhTyBDNrQkinSl1ho7N0oeUPdhjPie1Q=;
 b=Kr6rchjfsjEoLCx1gIrf+1dO7wYJUOqLVCvUVAlOpPzXPFvVBA0XsncjS6GgVjwcUJNlXm4vc/vXKLACMb1WWsxxuIAgJHeSFRXMGP+c1ljRLRO2ptUX3eyRDAHQ1im92K0C3FczKslgAg4DlOWxydHBcTz0TF2W3MDwOZ2JR0xgdhIClicPHpi5tGgErHHnJj2rsQKWJyEwyvcjsACnDCNrn+Srf15byhr88x3qHNRKRLehvVa4UxCiW+FxGSZ3ggSjjTtceQRjZ0xC/yTBdYP4S7wZiO5cT9H83SsXVp6b+O9klcok0yPAF3a2b734tSV/RJBwonliItrMKZGXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BL3PR15MB5457.namprd15.prod.outlook.com (2603:10b6:208:3b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 18:02:05 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 18:02:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 bpf-next 0/4] ftrace: host klp and bpf trampoline
 together
Thread-Topic: [PATCH v5 bpf-next 0/4] ftrace: host klp and bpf trampoline
 together
Thread-Index: AQHYm86zhN8thRtC40unIKKXXAqaq62Jc3CAgAEs7wCAABJOgA==
Date:   Fri, 22 Jul 2022 18:02:05 +0000
Message-ID: <725A5C03-EEBD-4BA9-99BE-37CEEC802F66@fb.com>
References: <20220720002126.803253-1-song@kernel.org>
 <257B5D9A-7A52-4396-82F5-9895782952BC@fb.com>
 <20220722125632.6b9d5ff6@gandalf.local.home>
In-Reply-To: <20220722125632.6b9d5ff6@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df226689-a4f4-418d-2234-08da6c0c494f
x-ms-traffictypediagnostic: BL3PR15MB5457:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NPrbRufaC2T2tL3OQ0h4S9SlsqRrErMc2kpTNKprN1VsKPonNS4ctnEYeF1vysPwPbyq7LHmLEIM4y8MR8/6bJvKlDB4wMq1kdFxFezQD1tZB8HJdc2UxEc5zx1KvYedAjavrpXFhcA7idkARQbMtTwFir4ZbWioOoPgt5aEdybsegCMpGns48S11vEp+mmiEsRFXGKJicxvY4oJkNdJ1ZL0wVY/a9+UAL6mNjRtR1stQdHshiWcz+uqnhLs5CnAgP73FqNkVsazpaCBQX+yohJ0e21e/ir4Uhuyy1vhefyOjWFt76A25Lj3q+6KmXhquSLx4EcHARLDKgkHkQ3eB4OeXA4hjXfp6FlNXHYyjCznHDJixWPSuPvK6hGhVnSkkq6UloWRoIsCahrvR+5toUavYjeyXLYwH0FIcfYscycgqx32m8KnqlVg8oVEs+bdgd4TPgKaAMDYExIWQD9E3qxPPgQK2lVPiLEjw2hdpoMByMtjy9IwaIL/pffMfyxZ2cFqP+ObEy8isYFDrjiBbVil0MD1eHr/7deE3GLOhm1rrOpxTEIwoCJoOB/qSe5eTVqbofEN8p0sW/dEUie1zwvL+pG4y4kZ6c0/uu5IWeGml+Xcoabb6rWmXtfe61TjDbkI6ZTaACUyFDwQOlAKpEg6vVB3xxt6+9qy+oI+XRp0kRvZ8oTYT1Jvg/SlHipTnxu7/fVlGit76ME25SlHrapC7tne0aC+VgvzdXekBRGzdz1dDJk7ZrozM9G4rrioE4quwm0PQtDsRYwVha4rjOXfCe9zoIbG0WXMfR/JQG57e39Za/gZUMQepSEib5d9LeUUCAWuJsGs0ebPcodf0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(66556008)(91956017)(66476007)(38100700002)(66946007)(122000001)(76116006)(558084003)(66446008)(53546011)(316002)(4326008)(71200400001)(64756008)(38070700005)(478600001)(8936002)(6486002)(54906003)(36756003)(2616005)(6916009)(86362001)(2906002)(6512007)(186003)(41300700001)(5660300002)(6506007)(8676002)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jKRHE2jL3NgA7Koy1ZWPoDvpOg/DXuHkb1fkOatGtjsq7/pfOfPlDXnpyW3d?=
 =?us-ascii?Q?Cuy4G5a6HCRKzs2dJg7wHbsUETJu111wTV8ipHPa8uF8W1XjzefajlUA0Ndl?=
 =?us-ascii?Q?5sKlD2u9mW6H2b2G8se60aPdZkjmLdXR1/QTE1K53BLTdXY12d1FlpLT1jYj?=
 =?us-ascii?Q?33vKX5Y727OQ5ACVLDhF9kBRfMT0qxklefoFgZQAfQE0ykG02lW05HEy5qFb?=
 =?us-ascii?Q?0r2oIQNvlbgxE2n0KTctuXaLwmnn0uuz6TntcSrklsA8gPGyf5rhp3yscOlb?=
 =?us-ascii?Q?L9tlESbVCXqaeWOL0wkwvY13oiRvQwJ8kG7qnMH8vcleG8zBP8zHnRhoh42F?=
 =?us-ascii?Q?LTvfDqNKTbYSobnN+h5OU+9SY/7SxWKRYKhMDS/A5CD+K7HouCz0EnDQamGV?=
 =?us-ascii?Q?AiU6JPbwcg5U0OivlTd0lEdkMx5mjvBKmxwMKW/n4AHmnu2x/KckIas4MsdD?=
 =?us-ascii?Q?s0NPScRZR90Xp9BocHcaBbVLi9p6m0Ap+7YFLCVVd2REecCSzKYLo8lQoiRb?=
 =?us-ascii?Q?aJtelAxtUQd1g1Hvxt+JmCRAHwzk9nrtw0ZbU5Ui+2rfdoro6Gd6uKwhNjiP?=
 =?us-ascii?Q?yaAzS6f8enOErSOazusE1/VF1xol2D0jbyF7zGM/PSN0qvj8LyRqd2mKFQNw?=
 =?us-ascii?Q?G5iHtJvl0y6fzu2v7XneqVkIggK08ydnYvpN6C7bkfkNt0ZxVG7IeT659Kma?=
 =?us-ascii?Q?/bJbSZPwlhVW+vLo5hkdvwuh/QphotCNCf5KMpv1EFYAU3wPLya6FSJsIWVF?=
 =?us-ascii?Q?p/KxAwYV5kh+DH6+Mp0LfD1qe7L1nhwUK3yQjiMNbTDUCDu+tfruP9Yk24sT?=
 =?us-ascii?Q?PyiTj7GQEIWthkAqcG3DknQw+26MUF63ibxGfxlGEm8b0jYiXDnH6hfjZCdO?=
 =?us-ascii?Q?mtHrseaP1yleKXLkudNhsyCNFk0Q3TP7NF8XlRuQPyYi9B/3vh29I6oY6ibR?=
 =?us-ascii?Q?8WmhCOcJnEnC/W1QTj0YuKcJeZII5hqV6fGljQ5Yky8Er0C+08+scofBBQem?=
 =?us-ascii?Q?Ey1L5BP615I202+wGAEBDwMFi7Isz2u+57CZCHwHLpqm4rjQ6LApb6CMJmAc?=
 =?us-ascii?Q?Ton3fkXAsf2NpuHsz543Eyyin2voWHbEYN2B9hGitSJ3K5sq2bi88RDWHRNE?=
 =?us-ascii?Q?p4H8jhOTtTD+w1zKjmUomT/YzJkW7h01F4YSUGYvUgBLV0KafYwxycIuGlgc?=
 =?us-ascii?Q?RfiSJslr4kE8IGsdsDWRkaFKRhhAoJFVW6EwrOO5zbhOI5sXv7WDdjPiikYt?=
 =?us-ascii?Q?mI8iv3MIyMnqAD4Fc4Nul5IkhylaV3XYURv26SMkerWB0AbCEBVH2to/haey?=
 =?us-ascii?Q?hxk4T1wgav0ZiNZOkdarDTSsk9R3/3SAzr79unqjY7IqTmNT1+lQGlIKBar/?=
 =?us-ascii?Q?0g53EdyODPucZfW5lX0+vVW5dnF/HykFWspiTnvJJU64jzShXPrpZ/jDQuhD?=
 =?us-ascii?Q?tQi8ujv8S4qQkKSUt1wNMhGexIZt0a70053oSVwCexfVGxn0bedYM754RdU5?=
 =?us-ascii?Q?yvJ5KX7LZD2WZ0nK1DlNp9E5nq7uZLZfc2RRMtlhGmC69sNeB96g6PJc1lA3?=
 =?us-ascii?Q?H0Uu6rEjuW3AwBr2ctB+0tkt1YmM7mgrbRW3jZZPom2/72aLape2s4hws71x?=
 =?us-ascii?Q?/czwSMWSMov6MAA9Dqu16EA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <971A8AB46C1FD24B8BFF66B7D3A1D553@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df226689-a4f4-418d-2234-08da6c0c494f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 18:02:05.1208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmAy1PgCGGg0YIgoQIfbu/J6mYZLBG1/5ry5bkXmVZ+/0Tj20VZFa9YFBMaaMcswndHW/6EQ30NsmV3xWH9aew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR15MB5457
X-Proofpoint-GUID: NDcn21S0J3_iCbeurUgBEree7MU2HSSa
X-Proofpoint-ORIG-GUID: NDcn21S0J3_iCbeurUgBEree7MU2HSSa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_06,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jul 22, 2022, at 9:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 21 Jul 2022 22:59:30 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>> How does this version look to you? 
> 
> Looks good. Thanks Song!
> 
> For the first two patches:
> 
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thanks! 

Song

