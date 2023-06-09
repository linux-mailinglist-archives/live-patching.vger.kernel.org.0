Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE44672A040
	for <lists+live-patching@lfdr.de>; Fri,  9 Jun 2023 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjFIQfX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Jun 2023 12:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjFIQfV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Jun 2023 12:35:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139421AB
        for <live-patching@vger.kernel.org>; Fri,  9 Jun 2023 09:35:19 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3592xl3W031038
        for <live-patching@vger.kernel.org>; Fri, 9 Jun 2023 09:35:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=NAz/E6CyEWPc4rLLVCbt3JNcEiA0F3+spOVkZCzfG3w=;
 b=DljwLdt/P2g4lIhVKpAaOwv8DnL19vKvLdxkJj9xNqvdLN1R7oQwqsHHn5EACmVBwPnF
 N0ezXOYZcxWs3m6sy2wgKLkW2lRgJlAn8qYlxckOihp41yA0ueSwMHiJbU7s9WR0fvL+
 WW4eTYoZN5ZOyfwg6+aM4Pp13RgAYN5fIKVbS7140UFJx7UuQ9YgWG63t6vIqYWIfG/M
 oU7VH6Ic3xZQrDVtGi6bYHx/Q4OLrY0O97UoCy9pr/v0EIuhoPVpHCqYD5SkDimUl3MK
 cqCXpS+gH5ibnKorr9YCNp2vmcu7x2zn3hJQfab3Xzi2Kp+IXg0dThVlAkrdFVPKpTOT 1A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r3us9vpy4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 09 Jun 2023 09:35:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrwVJoOvmksW5EwomynC9Y259UEhAkvlNqsYvQpPjDxfCROvIKdYw4oDYeedoYlxwy1gl0QG9kkli+XgWegPGkkCKvEqjSZkUcoLocomLMFNGFWaQJff0M/yQy7bOxpg6Nd2lU3iXYN/nnmTijWnFQD73/6vfrAi/kuy+Kq/Xilr6w00kpXRe8PFBjqpolv1rHD/tYuvg7Dm5FgKWuHJavqoFz+zE+DBB/YWuqr1Ev04WODUDF6g75mVEeLh0AnooX5GEu1TSoXm2evFRs4QBG294Wg6b9yldMb3+YArcXwOnzoe9svHtsAX1+3D8nbGK3puYjBxKQOpjnSClOAiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAz/E6CyEWPc4rLLVCbt3JNcEiA0F3+spOVkZCzfG3w=;
 b=Jt83dbMzTmDsi0qTqaCuL5G6hWVeXoEM+44llsynmHNQOAUzpXoG7yPRpHasJXwe9WYanLEpWU3Mi5aELMLuRqTRPRW64hby7XKmix5X94MNiPeCdeIYJ7EBh2NA8dWPJS5IjZ0fwc/l95SoCO1GPNITQIoyyKvGUSmE/XIWkXZBlwbd5aLIGUNa68ZNQ7aU2wCG296aLkkWwT7zKOyXgvyc7J9aS1GioBjvRTEhYMBZZZaaW5Lx07U/TD0PZ06zD/gqfnDthOS+q53L792FF8iu5HIgD5Vi9t2zv1aZudbThE33IgerXAL5p/Q4shv3K7JBeWVrdxP7dCrgdzvI4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3966.namprd15.prod.outlook.com (2603:10b6:806:8e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 16:35:16 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%6]) with mapi id 15.20.6455.034; Fri, 9 Jun 2023
 16:35:16 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH] livepatch: match symbols exactly in
 klp_find_object_symbol()
Thread-Topic: [PATCH] livepatch: match symbols exactly in
 klp_find_object_symbol()
Thread-Index: AQHZlalc1ytCUMNDxEyW/Ni7kqjUhq+CFzqAgACeJQA=
Date:   Fri, 9 Jun 2023 16:35:16 +0000
Message-ID: <A4BB490E-42EE-4435-AAE7-2309E384C934@fb.com>
References: <20230602232401.3938285-1-song@kernel.org>
 <ZILQERU8CJQvn9ix@alley>
In-Reply-To: <ZILQERU8CJQvn9ix@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA0PR15MB3966:EE_
x-ms-office365-filtering-correlation-id: 2aaa0227-3e4a-4326-6b3d-08db690781bf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aa4KLmypgAFEddh4VPDtbHw+rxj9er789JwAgAcloDC192yANJnWkbnE7JGd1hJvwhTS5Cg62ENbalnW7m6WkdwmPm71SK528xVRyIRSs2nn3izY2g9/wSb4ZEoCaAFP+JpP/GU6Sgjx8tn05kiPxDCBVGpULykNKR/aSRcLnjVssyMofmg7PxZUd63MR4X/hgFomgjJ7INuYpH2qiiAPrh0Nd3R7AaJD6V17fQG9+iZ2YX4Blpo3bS6BIGAx9STy4as+t+dF1QZsf5Ie1B8H+E9VpiBapmM62DsrQXn7pd2bwOySUQgWaX8+OftGIZRmoavg56NS3AXzLj21cvSpiF5c24ayBhkSEofmbwtlawfcFlcaxE/rrD0OjDfOcaQpnor12i+c+KwNVpQHzFDiXXNOZ+CKwy6LQahzs5k706QMk1qQX/9OX6mhn94f2U96aXXCk/VNDJhxB8Xk7Aop8fn5NbomOkfUZFPrThelgkGSMYrHRQkL0mlB4I64XWamN3xS3y2e2KlbBnu967P2rmYbU0rkCEjnPoDkB7CBa4r69+O0wkzGK4WZNPpM2UCyl1sQ5fxeXqyYI0IJNQbOyQ/DcnZ1n89MhG6buIfoWFyteKWxoWlETwYYRY+Nak3CYbX98JXQEWNUuz0B5qvlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199021)(8936002)(8676002)(38070700005)(2906002)(86362001)(5660300002)(107886003)(41300700001)(54906003)(478600001)(91956017)(122000001)(36756003)(316002)(38100700002)(64756008)(66446008)(66476007)(66556008)(66946007)(6916009)(4326008)(76116006)(6486002)(33656002)(71200400001)(186003)(83380400001)(9686003)(6506007)(6512007)(53546011)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Ec/Yn4uH4YBp5YoqS13aVeMLWbTSEMhKG+aZpm6h/THpwIRc7ufj0QO5zwt?=
 =?us-ascii?Q?UzcPuuXHUCOAHWP/IOjBJf9BI0Ox/pTapJnBglcX8ignI6y6HfEDm89Bi0qd?=
 =?us-ascii?Q?BtDoLlcJQw3Dj38e+dkPuvwQhaGFMeKQX9sl3oAjm46DyTr+JTwgF6vLDcvp?=
 =?us-ascii?Q?JTxm3o+ZQ3hDepmtYRRbNXjsM34zAnI+NK0D7fn38xzR4xdiqe6DHqT8F0QT?=
 =?us-ascii?Q?70jhFzvapppIPij6RrCbX3Gi1l6or3sPgRd9U2G65evY5Up0dl5SiOWRfx0u?=
 =?us-ascii?Q?rMOTbS22ARDFt/5hMl9O5pQPbYVehNsdEPf0WloxGZpRQQKw/t3PYv4s/t53?=
 =?us-ascii?Q?Dnf6OKJKwk5zdXmiAdtQC/OpshNVEOcxnO0j1AueYv7hc4L3CfT94VYthU5k?=
 =?us-ascii?Q?I1StV4gNhehprtIQMBil0Vte4Yu/BCQKKP5JQ1yNSj9ZBxumOoZ1/4x4NBkS?=
 =?us-ascii?Q?p13+6ual9dJZb8GGH3SaalRl2ND/dksmw1u4EbU9LEuZtP+zdKJRW8yrYiEH?=
 =?us-ascii?Q?oIcSe9qJscyI9ta2/C2FpN3QxrrHC81c7UbA3KYsWiSg4MyVbMu5FFlJyvxD?=
 =?us-ascii?Q?zuitP9Fy5UsQZKsxiHFuApJG6Z0jWy0M7XIFhY6kJiG5dzIewrPfFIdY5c1f?=
 =?us-ascii?Q?UvE7YmEVuxvUZ/Uatj4bUsdqIh4xASjjM7GgSBPlLdVJiiL5mN63iVuWRJTd?=
 =?us-ascii?Q?H7Eb2wuN9VeJDikwc2z+YV8YKUUzpIy/TRU1/zokJhC9UlkKWvNyz73gtppf?=
 =?us-ascii?Q?LsplkDe1c4/S3Q1RcGOrGWgxkql+aMB/K4Aju4QVFWotbDjBQeRsQaz5Ha4L?=
 =?us-ascii?Q?NDwLhTLA3RtiMxLok+1eKIr+diCaLEFhePs+rLvrhr9tdAOfbhzx20A5AYYO?=
 =?us-ascii?Q?lsOuzi0V1jswMvmP0TLaMtnWxzHSzK2gP5wVMuPswi0OgZc7WHj9mnVBUPYo?=
 =?us-ascii?Q?J4geFA6gVOIH3xToBi/pvxABodGb9PdrkchrSnaUFYwoaXe1yJWiMail+aP0?=
 =?us-ascii?Q?yRoTEc80t1PN6BVLC2UzHjVgA3Hi0do0Llh/jXFrzFvwYfHqQdlS+xN6wpR0?=
 =?us-ascii?Q?Ep5PBX1ajvFA6Xv44KhhIdUL9YhUNTNCLwwoB14Ouasi2MwZzTKS5f3uNM2H?=
 =?us-ascii?Q?hfj9YREoAMwfy2B6k2Var/yJOHaYkQSjfOsgOW2rDjLv1PCsyf+tyAB3kyPE?=
 =?us-ascii?Q?rs8h6DyVupWcxWiraEd6duCKRqvpI0+mwdUwb/s3gyi8QdgaefxpnKEpgFZ+?=
 =?us-ascii?Q?XwxwNXeSOAUCSoztLT/6PXCojRFCGisnWqqGg+XWB1vsgj8oCYEGZT/4AUc9?=
 =?us-ascii?Q?gQZvYrJ2VCQBBtLgQe5oeBrvP8xrAIM1LRsO4dXFZ7dWxvuVqPtDULrgM0Km?=
 =?us-ascii?Q?OpUnKwpxfR7nnhXHgotKqGPy158+SQIGrFNyzv+9rOGUipUS5G9etGj933eZ?=
 =?us-ascii?Q?j9LYYgg02ZUFFmf/+b4eY1xrkWuuBF2dCZWRShpV9or7wBVjf+Vr9THlpjbX?=
 =?us-ascii?Q?UI75roBcVm5SAw/XImbkXdqSMGpq5JdIXrq/P/9Jve6yarRVWC/5dZ6aoW0V?=
 =?us-ascii?Q?qdxmExgl27aSs6YdMxA1svutQlk8hCDx4qpgd6mfrmzpA8akLyQfM7fas25Z?=
 =?us-ascii?Q?zM1EaU5X0wU+t9XKXxJesgQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08231786301ADA40AA109335799E41D4@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aaa0227-3e4a-4326-6b3d-08db690781bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 16:35:16.5226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JB1iLjqlefB1/ccVHLhJCbLnra6LIHC6GOk3heEBucy79uf7jxhOcwJRDVLEPCSwMETJ3RFfdG4SppXYuj3uKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3966
X-Proofpoint-ORIG-GUID: uO7acPZUO2hSVZWAt1Me5P1du2GR6GxK
X-Proofpoint-GUID: uO7acPZUO2hSVZWAt1Me5P1du2GR6GxK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-09_12,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jun 9, 2023, at 12:09 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Fri 2023-06-02 16:24:01, Song Liu wrote:
>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
>> suffixes during comparison. This is problematic for livepatch, as
>> kallsyms_on_each_match_symbol may find multiple matches for the same
>> symbol, and fail with:
>> 
>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
>> 
>> Fix this by using kallsyms_on_each_symbol instead, and matching symbols
>> exactly.
>> 
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -166,7 +159,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>> if (objname)
>> module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
>> else
>> - kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
>> + kallsyms_on_each_symbol(klp_find_callback, &args);
> 
> AFAIK, you have put a lot of effort to optimize the search recently.
> The speedup was amazing, see commit 4dc533e0f2c04174e1ae
> ("kallsyms: Add helper kallsyms_on_each_match_symbol()").
> 

That's not me. :) Or maybe you meant Josh?

> Do we really need to waste this effort completely?
> 
> What about creating variants:
> 
>  + kallsyms_on_each_match_exact_symbol()
>    + kallsyms_lookup_exact_names()
>      + compare_exact_symbol_name()
> 
> Where compare_exact_symbol_name() would not try comparing with
> cleanup_symbol_name()?

The rationale is that livepatch symbol look up is not a hot path,
and the changes (especially with kallsyms_lookup_exact_names) seem 
an overkill. OTOH, this version is simpler and should work just as
well. 

Thanks,
Song

> 
>> 
>> /*
>> * Ensure an address was found. If sympos is 0, ensure symbol is unique;
> 
> Otherwise, the patch looks fine. It is acceptable for me. I just want
> to be sure that we considered the above alternative solution.
> 
> Best Regards,
> Petr

