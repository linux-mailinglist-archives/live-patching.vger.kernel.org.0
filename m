Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2089F5787E6
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiGRQzy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 12:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiGRQzw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 12:55:52 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404C02B624;
        Mon, 18 Jul 2022 09:55:51 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGhnGl004257;
        Mon, 18 Jul 2022 09:55:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=TvGewtFymnwfBlmEI+2gRnmdyD44DcHL9E2IngSFnK8=;
 b=FJoPqec6Od6bS+eyT/6PLrph1r1TcUtsjxRSiFF73oJVcyJzuJkSYYxp42+RHPoyIXKa
 XKt/Cz/bJIQoRB1y0Wo6Kcw+WlFUHZ5PQULmDdeiyp56UnBJH5E7Yv2ymPn9yAWjo4ei
 tQpEEYxngqIpK43S+8UT4WYJZyGBKl8p4CY= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcm64ebbt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:55:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7do+IXKcyIADHHtDeLnnGvVWtKLp1W11JRc514OOgsBFDex2YQzRVThUIWH6SbIHLthKvN59+ircLEBvNgA/pSUNK9CfsxmSK9TUROygUF9yl0JCd4+XovVigbdF0Wq8QAlyjpqJscm7sRwi9OaCY6L9N4FIe0MRVJnAGCejAvqEmy9AXEHCazymnbgkdal01aEqTbAqkLw/XtJb1e0rrMc7jXuZWSepqiEGYC/Cg022sfCbDM0zRuWaw4RHG5cMw5QKG67LfQ2diKfInHkYC8fxWECMHfKq+k/cs4Mzm6YPVhN7aFpTds88Xy2MBk/AA9kBFmVCcIRgokZji9vtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvGewtFymnwfBlmEI+2gRnmdyD44DcHL9E2IngSFnK8=;
 b=Zdim7f3Cx4VkO3ridD6+DOyusoJOqUVWDVyQrGg58GvTrnhKRUYUMZABXXBmlKPmQgKfVvBcyXfdXD4PTJ0tCmA9T9LSzHBCRBMmd/dfng5Loe2QEIK25nPg1FoIkTYamGZ/bQvGcFA5PCrC8dWNSOTE0dG/bU04f6uzM85My5Xe8S7it5VwtjYNvQtzmlkODelsKWAOOeZt0C+rgJNOGf0/HE3kQUyX3u2v5851E/H9DoH2g4KbsFXBFJJriYPmyYaN+a13D0k4ZKXxViA+EaOfUFJWPAjGNzWukxmOKmJEDMwh/OG70uH6xqbOSRY+aHJgb1MRW35TBP4/5qHmBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MWHPR15MB1135.namprd15.prod.outlook.com (2603:10b6:320:23::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:55:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:55:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH v3 bpf-next 4/4] bpf: support bpf_trampoline on functions
 with IPMODIFY (e.g. livepatch)
Thread-Topic: [PATCH v3 bpf-next 4/4] bpf: support bpf_trampoline on functions
 with IPMODIFY (e.g. livepatch)
Thread-Index: AQHYmjtcMmP3V3HYAESvvAj8lc6o962EGiQAgAA/1oA=
Date:   Mon, 18 Jul 2022 16:55:46 +0000
Message-ID: <A57A84BD-F140-41D6-90DE-146232B72F86@fb.com>
References: <20220718001405.2236811-1-song@kernel.org>
 <20220718001405.2236811-5-song@kernel.org> <YtVbBFYbJGiRAv99@alley>
In-Reply-To: <YtVbBFYbJGiRAv99@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8107695f-bb5f-462d-cda5-08da68de5c3a
x-ms-traffictypediagnostic: MWHPR15MB1135:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TqNLc6NTfpvSYBb9h+5qRr/3HwtWzRje1rXHbhGYVYgzbuqu5fDM1yyL6g3whA/87kAQcPwuOrsHXd2F0HMfUGocFAsqxCvgcGpBfbJiMoaCNw3SCq0QW6M8kSUhEJvUR0usNbO+2277mo/KmYzgZ872Ug/eU53LJpiQsIgJZtRFw8zosG2jEPX2Ha7XdY/nuRWrcTtVsPsXBGMywBhVm5FeJL7aO43xn/oR2SxHboec0zhZn9huQwAc/43lLT1+j2R+9FMzcUUq2qHra8Ji+WOHpRyZ6eu78OQpSpRgevLXyJmm5sAdDQ++GTgLJXwl6Wob07vMGa1XI8FvaFG4LRhNXUBm2BJirJdQ2L3i0LMGw2TVd51pct8ozu+Rk0KSZk6OOHsuBTQpiLjt+cN9Z12rK5ot2VXkgcwmt0d8iDRTuiY2X1vrlLjTy9PlLU3ICrj3fwwWkZc9goowE4IjqXBpefyvgAgJAu7D18wAutEEXSea8tu2TVe+ULwKbvuWdYrqoCzEcg76bgrj3hUbvInY6YdvKk4lAO5rS3l6AEnDCHKRCl10kgHTkLa/06WHU6dc6KUAFEQ76RHCqwso2L9y4FIh9b+LKwlFV3twMN7asR2wi/6mWnC0Jy+OtPJ1k06r23KYT4OzB7vcOElAdeLCDmuJNRPjAt1YNTIohQuSlK7jCc7C60lyMLh4KDznybOm1Hq912aTIijqV7VXqbed16ojTTMdRFiLHCr3M46mJhl3+9uJfz0FRpLDQFFuONbHynXaKvfRmZhq7GkJW2aj99GzK4oPTrirYY9qnu5rmKdvnP2rp4B2GNT71rgrTa/kQVlRzIcfl4hpG2iTyDWm+1ovH92X/uURay2+2YuHAD8GnaYMlo8GPHRbLagr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(6486002)(41300700001)(71200400001)(966005)(478600001)(186003)(2616005)(6512007)(6506007)(122000001)(83380400001)(66946007)(53546011)(66476007)(38070700005)(38100700002)(76116006)(33656002)(2906002)(8936002)(5660300002)(91956017)(316002)(54906003)(36756003)(8676002)(86362001)(6916009)(64756008)(66446008)(66556008)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k/zMIfW37/WbJE34C0nB+M/IDGXgXfb1vSV6yCTZPLEZ7HdaoXSIsAgXrsdh?=
 =?us-ascii?Q?fbJ1+V9Gb/vyB068ED2KU0XUSKMHuzLXzHjnkLNgRvV3SFg9tS6a5Qan1/z+?=
 =?us-ascii?Q?bKmgo/0g1wWvpzHOHeLTlTjTD6fZ2dCs9NKN8QyTpZ/5cg7exPNCJexJnsoK?=
 =?us-ascii?Q?13ZrMOQiA5ncxr38kWfeyTKDF6aC7qvi9/yW/cINSWxXpp8HdJwUQvoUeFqT?=
 =?us-ascii?Q?trCHX3O0H2+g/sFtzjvz7ObcobEskbwKNhkbyzMMK4A6fxVadwNRGxmqNQRn?=
 =?us-ascii?Q?sOO43oUHroOlvUdCxvaXWfOpdzY/O13qgTt4GeoyXOwQTBpmwonh68hBzS/d?=
 =?us-ascii?Q?YZZmzb8DWPnhO1Q61q2epK3uOhqgBHtL0OnK0e8trkx0d7Demxw6lBH9fpTT?=
 =?us-ascii?Q?S55aELcuEUNebJ0tfwieVr81j234SPWbNs+kDpzWSv/EkKwE2u1kEeSd73ye?=
 =?us-ascii?Q?mOb932ISBDwGRVuwzzuSh/fhX9qLHE4MjkU5Gwe9MIeYcMzreMpx+itD+faH?=
 =?us-ascii?Q?Eb0CWLufiK0KHCnjHMasvOjxB7oqzoWARZhTpH55T8sYvifDnQIYN1Q24Uqd?=
 =?us-ascii?Q?HtWIXmM2PyY9qcGbSYuJImruUEhBKGzpvF3nKefbxWEOUDOy4Y6xTXUPT6tP?=
 =?us-ascii?Q?oDkr3hGwMeTNs5rnD15KuaWHK2URIpmCXP4IeZj8F4yqwSimE9detBFpVBHv?=
 =?us-ascii?Q?Mcis61fUFOm66iWRAejJcQbm2AZ9PC1JcueMRAiv4Xkk72bURrRD9JnjS4cz?=
 =?us-ascii?Q?zp2AdBaEvQ+dc75lQhSDXRLRqJEezGDoI5V2ll4UErq7SlRtQf8R1wsG9+00?=
 =?us-ascii?Q?nmucRVmaR+5X2P1J71bQMk1l1Q4GmbZmwO2nLKPWmqqk9VRp1ikXPzd8DNVF?=
 =?us-ascii?Q?1BL2jaNtgXJU0X9ciN66gKLUYOVqtJoiKnCmGL8DAcufD5fgwaoNdiSYzkyQ?=
 =?us-ascii?Q?VzvH5vpfeHQk2BRopRou6aY1vjbMC2tk+wUUlGQGIw0kTgd/G+lLssbCgK1g?=
 =?us-ascii?Q?v7yuVhGSoiUo+qk300i//3G2QZZDv4Be66zesPec563mm5heVxzxcYYzJwLa?=
 =?us-ascii?Q?YtaSQHhrzFawa1VZb/Ksjkgmo1VcA1FM5DhLqxRqlxvy+Fu2EU271quysLSH?=
 =?us-ascii?Q?Q0+tslGEVEMsFplXfEgT+WrhBksyaSEHkhLegtHErM6L+9LichEuagijjki+?=
 =?us-ascii?Q?nkxEMtZ6o4WKcQbBdU/LSs+Q1cLGH9PEFkHCa2uU30TYzkJPEQ14oiVcToPu?=
 =?us-ascii?Q?H3RGLgR56Z+8tb6DCwvIuHm3M2mbZvhIfqfzy8YLQTkCNTy1T5GIyrblp6u1?=
 =?us-ascii?Q?dlJUlqn2POFYcDoWb59HB9wtChpcDHyG7rkJqMKwJqWLXpV5CjzBJ7jgMALg?=
 =?us-ascii?Q?gqzNzvvuP2t+M9VaboHXwQq2FOszfssWvm0zpzldW8arRYlrnZGg0DMGwflE?=
 =?us-ascii?Q?QUOEToAJLOUahd8qhM7bB0JUOUDVfuymjq5eVBX03Nc9uoLuzIser8LaFdDO?=
 =?us-ascii?Q?50WBOJoGaDmWE117q3zDqJ+TlKbW7w4ZftdelueEzHCSVzrXkS4GDbhLVVi5?=
 =?us-ascii?Q?RHHI4bJdKU1lJMzHP/bbThsSTP1I3myT3yXZjEwy9BNgNHwynEC03IYDkkMC?=
 =?us-ascii?Q?//T6P8nzZRjpKjrx0eLFGCM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFDE8CCC36F6CD438AB852FF09196FDD@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8107695f-bb5f-462d-cda5-08da68de5c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:55:46.2608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ojzsbyf4h+LsaHP0uht6HfDUxiPxokH/4CaepLBCDpznzQPSx0J6Lf8s2+EN3FSwFrpIaHKamA3LlhCqJK0w6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1135
X-Proofpoint-ORIG-GUID: Yo6qivfs8q1r_M4Lx9bjGH-XSoyy4fVV
X-Proofpoint-GUID: Yo6qivfs8q1r_M4Lx9bjGH-XSoyy4fVV
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_16,2022-07-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jul 18, 2022, at 6:07 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Sun 2022-07-17 17:14:05, Song Liu wrote:
>> When tracing a function with IPMODIFY ftrace_ops (livepatch), the bpf
>> trampoline must follow the instruction pointer saved on stack. This needs
>> extra handling for bpf trampolines with BPF_TRAMP_F_CALL_ORIG flag.
>> 
>> Implement bpf_tramp_ftrace_ops_func and use it for the ftrace_ops used
>> by BPF trampoline. This enables tracing functions with livepatch.
>> 
>> This also requires moving bpf trampoline to *_ftrace_direct_mult APIs.
>> 
>> --- a/kernel/bpf/trampoline.c
>> +++ b/kernel/bpf/trampoline.c
>> @@ -13,6 +13,7 @@
>> #include <linux/static_call.h>
>> #include <linux/bpf_verifier.h>
>> #include <linux/bpf_lsm.h>
>> +#include <linux/delay.h>
>> 
>> /* dummy _ops. The verifier will operate on target program's ops. */
>> const struct bpf_verifier_ops bpf_extension_verifier_ops = {
>> @@ -29,6 +30,81 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
>> /* serializes access to trampoline_table */
>> static DEFINE_MUTEX(trampoline_mutex);
>> 
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex);
>> +
>> +static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
>> +{
>> +	struct bpf_trampoline *tr = ops->private;
>> +	int ret = 0;
>> +
>> +	if (cmd == FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF) {
>> +		/* This is called inside register_ftrace_direct_multi(), so
>> +		 * tr->mutex is already locked.
>> +		 */
>> +		WARN_ON_ONCE(!mutex_is_locked(&tr->mutex));
> 
> Again, better is:
> 
> 		lockdep_assert_held_once(&tr->mutex);

Will fix. 

> 
>> +
>> +		/* Instead of updating the trampoline here, we propagate
>> +		 * -EAGAIN to register_ftrace_direct_multi(). Then we can
>> +		 * retry register_ftrace_direct_multi() after updating the
>> +		 * trampoline.
>> +		 */
>> +		if ((tr->flags & BPF_TRAMP_F_CALL_ORIG) &&
>> +		    !(tr->flags & BPF_TRAMP_F_ORIG_STACK)) {
>> +			if (WARN_ON_ONCE(tr->flags & BPF_TRAMP_F_SHARE_IPMODIFY))
>> +				return -EBUSY;
>> +
>> +			tr->flags |= BPF_TRAMP_F_SHARE_IPMODIFY;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		return 0;
>> +	}
>> +
>> +	/* The normal locking order is
>> +	 *    tr->mutex => direct_mutex (ftrace.c) => ftrace_lock (ftrace.c)
>> +	 *
>> +	 * The following two commands are called from
>> +	 *
>> +	 *   prepare_direct_functions_for_ipmodify
>> +	 *   cleanup_direct_functions_after_ipmodify
>> +	 *
>> +	 * In both cases, direct_mutex is already locked. Use
>> +	 * mutex_trylock(&tr->mutex) to avoid deadlock in race condition
>> +	 * (something else is making changes to this same trampoline).
>> +	 */
>> +	if (!mutex_trylock(&tr->mutex)) {
>> +		/* sleep 1 ms to make sure whatever holding tr->mutex makes
>> +		 * some progress.
>> +		 */
>> +		msleep(1);
>> +		return -EAGAIN;
>> +	}
> 
> Huh, this looks horrible. And I do not get it. The above block prints
> a warning when the mutex is not taken. Why it is already taken
> when cmd == FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF
> and why it has to be explicitly taken otherwise?

There are two different scenarios:

1. livepatch applied first, then bpf trampoline is registered. 

In this case, we call ops_func(FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF). 
_SELF means we are making change to the DIRECT ops (bpf trampoline) itself. 
In this case, tr->mutex is already taken. 

2. bpf_trampoline registered first, then livepatch is applied. 

In this case, ftrace cannot take tr->mutex first. Instead, ftrace has to 
lock direct_mutex, find any conflict DIRECT ops, and call 
ops_func(FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER). _PEER means this is
called by a peer ftrace ops (livepatch). 

> 
> Would it be possible to call prepare_direct_functions_for_ipmodify(),
> cleanup_direct_functions_after_ipmodify() with rt->mutex already taken
> so that the ordering is correct even in this case.
> 
> That said, this is the first version when I am in Cc. I am not sure
> if it has already been discussed.
> 
> 
>> +	switch (cmd) {
>> +	case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER:
>> +		tr->flags |= BPF_TRAMP_F_SHARE_IPMODIFY;
>> +
>> +		if ((tr->flags & BPF_TRAMP_F_CALL_ORIG) &&
>> +		    !(tr->flags & BPF_TRAMP_F_ORIG_STACK))
>> +			ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
>> +		break;
>> +	case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER:
>> +		tr->flags &= ~BPF_TRAMP_F_SHARE_IPMODIFY;
>> +
>> +		if (tr->flags & BPF_TRAMP_F_ORIG_STACK)
>> +			ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		break;
>> +	};
>> +
>> +	mutex_unlock(&tr->mutex);
>> +	return ret;
>> +}
>> +#endif
>> +
>> bool bpf_prog_has_trampoline(const struct bpf_prog *prog)
>> {
>> 	enum bpf_attach_type eatype = prog->expected_attach_type;
> 
> Note that I did not do proper review. I not much familiar with the
> ftrace code. I just wanted to check how much this patchset affects
> livepatching and noticed the commented things.

Before this set, livepatch and bpf trampoline cannot work on the same
function. Whichever applied latter will fail. After this, the two
will work almost perfectly together. By "almost" I mean the race
condition protected by the mutex_trylock:

	if (!mutex_trylock(&tr->mutex)) {
		/* sleep 1 ms to make sure whatever holding tr->mutex makes
		 * some progress.
		 */
		msleep(1);
		return -EAGAIN;
	}

If livepatch is applied while something is making changes to the bpf
trampoline at the same time, livepatch code will get -EAGAIN from 
register_ftrace_function(). Then we need to retry from livepatch side. 
AFAICT, kpatch user space already does the retry, so it gonna work 
as-is. I am not sure about other user space though. 

The msleep(1) is suggested by Steven to avoid deadlock in RT case [1].

Does this make sense?

Thanks,
Song

[1] https://lore.kernel.org/bpf/20220706211858.67f9254d@rorschach.local.home/


