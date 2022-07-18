Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EF65787E4
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 18:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiGRQzw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 12:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiGRQzv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 12:55:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A4E2B1A4;
        Mon, 18 Jul 2022 09:55:49 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGhnGj004257;
        Mon, 18 Jul 2022 09:55:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=TvGewtFymnwfBlmEI+2gRnmdyD44DcHL9E2IngSFnK8=;
 b=EaWLoyqo1SnnOvrEU/XycyItz6fUoKCvjER7XngdTnsUjG1/PdWhixIPTelCrc/FFngD
 V0/9/mc2fTK00iPV+Zd2oQY/FzZWLIv5ym7zU4NnCJtdi5zofY5/sboUZQlw6O0LHBHU
 AslwE8y+PzOJ7i/X+usqNOQVU9M4Rt6E110= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcm64ebbt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:55:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0fUmvQ1GPyX1qXo/8p7QFLJhiQmPwaC/VTX5eq3euNCIy14WfeVDOvkS3XgxPVYVWSfGLck2ugtn8qx4FqwoNj6ttAu6V6/0XTtXJvwILKDKsh8yg08UvtoX871jCDZM+8HR2XMOG5p1GdP705TR1UK6dL2kJffX753kxT3R59qTDRcjT0x7w31IC6sxyQyCAP0XJNT2IkHkNLLaYuLsDTRZEqmcf1MZNYn8lc+k+01FugQ2t7CJXYSdLStXqJnssCIxf0R6Gpj9hYLkefwqqvzhZZxY2xdQQ3ExtNd4VSpVEzlMhZNcibPX8iyUjPXIxEjx8ohEhjbnmoPEIdCJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvGewtFymnwfBlmEI+2gRnmdyD44DcHL9E2IngSFnK8=;
 b=AVmNkSKSTYBq2QuprQhy6+u48gj4qoiTcE1K1NXO9NrFJGLPnOpDG210tjcG3CuxH84WuijlAluqEy4Zm9JUF8uCHItp2MXpKdZG5s1jvdnOU4DtPfJ1SKa9t3z/JpIRtVe1lufDuzIdej9a/OyPwOXWZKHzIZceD0AHFaWpg+LgLs/cIy2nH5W8ormIqU74kOQWekWXHuUrpNnit+Z8OM2N7dmgf8Gl6ZHZln8tGflcaZMr239ue7crmQ+EeISwnseySnfFIsLJQaZmSAXwXZMRuCPnjJ4MwhTt173DI+zNP6hyXuTtixMqJuMvcQx9bGr1lJYGwyRSYBNclhxpwA==
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
 16:55:45 +0000
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
Date:   Mon, 18 Jul 2022 16:55:45 +0000
Message-ID: <51C946FA-22AB-46F2-B655-1B236AD7F673@fb.com>
References: <20220718001405.2236811-1-song@kernel.org>
 <20220718001405.2236811-5-song@kernel.org> <YtVbBFYbJGiRAv99@alley>
In-Reply-To: <YtVbBFYbJGiRAv99@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b59f5a52-8582-48ea-d659-08da68de5bdd
x-ms-traffictypediagnostic: MWHPR15MB1135:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6YSW8ZhDBXdjzX7iJbEWN4uTwGvOnNAzLnpw9DuPsyDlmI63Skzw+8eqvjBUhhdbWAox9a2eKDENmgUfGUgtMLe9E7FY7sRc4On7fns5GwZ6WjWnF0DUhfcPGHdtT9ftYSafw3+2StdkUBdIeP/v0hDcD1twsTI/h+vovil2u7uER8QDY7xd+ySVqY9/ob8u/LOXqOT0uqxVicz5DQfhcjCKnDKhkBmOyKEg+cUCP1/KAB+NELdSnyrZHsQIqcUlpyHngbPwxmnHKMnE4UFyr8QfFKGrgJDIj6M4Gdz8lgwCiesMPLZdFgHU3EFbJi6usX0rTS9qCNO4beVIT1KMnUR/3m1HUlPpHatzgPFhyW9zV0lPw/CqJow83l/I2AmlYo+wf+19Xmd4vPMrsHuUtE1/eTtph/2e4675Pkf2t+8bhneQSZ2X5hcrU+dnp+PMifmYPGy/lVe4Qea7lPJnlT+tGvFJmII98QN5ZzrlDszNsQmepVaHnpeGzmsxUwmSanZJuVBjIA57XO/pMLGm5P+NxnilDjvQUz05oyO0hBT+VTD8kB2GVnGfHGuisUTV8NOdwJAVwZTwWrgliKotLUBdfUuQOgSc4uuolhJ2sSUTtTdzuwSCYGH6VsFG05tE3ohDf0WnKSz2+BH2+3UN69/4GXrgUUzZyY4Y1jVagcAFEWCtZBvri4kCvphL0yBhD40eX8bP19iIjHnLd3Y4xecVZ3zJ+t5kSSUb5C1zZvpaAHFIjga69N8SADIGLc1knGpk4jXIve7Tg+KjN+oiPILLV9orslD84Jffg2Z7+FajHdk/+oyeK8JKNXI9pJaCnB5M1nb/IgAD5usgq1J8zVBEO3HpTWjzYbUblGJBeBu/bYwAkZN+PqKep6IfA7y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(6486002)(41300700001)(71200400001)(966005)(478600001)(186003)(2616005)(6512007)(6506007)(122000001)(83380400001)(66946007)(53546011)(66476007)(38070700005)(38100700002)(76116006)(33656002)(2906002)(8936002)(5660300002)(91956017)(316002)(54906003)(36756003)(8676002)(86362001)(6916009)(64756008)(66446008)(66556008)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vEv9AqAhoHso0mTTNGkZDFiCfXy/tqJ4bF2lxSINBQGbj4WR0fY0bOaweW4D?=
 =?us-ascii?Q?qUUmgJFTzfx8qJGN5p5l/DMnAgTXFxPRFkQHlra+v4Tkzs61fFlEN01Rivnr?=
 =?us-ascii?Q?MTlca3Gz7nix5lA5V3tAokrJqfGPVeLIKpAFBckDv5CXAQFocnltM/rPDoHN?=
 =?us-ascii?Q?62jZHlvsRF3ahRh897PhhCHXxAnTdQyorvpgevn0tQTs5dT00OipDQIy0RtS?=
 =?us-ascii?Q?o5f5YHOLZFGwvNyFPC8eSdVIzztl0i2ckjcDwn6HGKBfiIQEa0CfCMC2o2kz?=
 =?us-ascii?Q?9MeyCgXiwXCeJNVtl7UjfNjyOvDqfFUcpJ/4f6TpjlW5lgRDaf6R1sHxhM4C?=
 =?us-ascii?Q?s7MSnlZ+36pif0Uva97UCiuaaqrXDRIkwB9xLmc75XGYHsWfh64zmIjvJSkc?=
 =?us-ascii?Q?m9gbdu5qbAv8XfLh9sYac9ho0DXwiKGxgpCq3gZE/IOi9EPvtebnEy0JYYX/?=
 =?us-ascii?Q?bju7LkzcidwXKckIyeQ5YuWO5Z4JWop6w0Lf8JzUewuYbkskMtupOY1Kj442?=
 =?us-ascii?Q?C8ZlpPTR2Cp5UcwvhP+tPmC+93z7X0NDddUh3yaewdfvzjl0FB6OyEp3rO3L?=
 =?us-ascii?Q?uDBOfjqeAofD58ITMQrOu190/qbgtgJzh9SMOci8phxY32ejhmuT8AweizFO?=
 =?us-ascii?Q?hLqVr4WiyrnzyNvXTvDyH4BUKL6BzRNHmpz7eKxApB9J9z4UmssAJkBbsHFW?=
 =?us-ascii?Q?FWbyvyjTXJCuCCPf0K4er8kGADHvcjpUteRiwQP5hDJftoAcsnwW/9ZPT/9L?=
 =?us-ascii?Q?qyRXOp80Gojgl3awMwtNo0xNGWSeAZMIF+WjZAsZkp7VBj927c73EsFcSZU2?=
 =?us-ascii?Q?Pv4UFBHl64iRWnPYacb5fLZa3+gTebiASMlR2rerDVXcX5GyHthsX02bPPOC?=
 =?us-ascii?Q?8ZzQoSnUSTv7KUQM7O+ipxnuJOrN2QmBPWnR7e6NSGCx2lYpCi1CRktAz7x6?=
 =?us-ascii?Q?u6qCgjlRUhRNNVX87ByUSq/SjBS0+iXEMxab2Y1K08QVd3h9X0yGLhd1mRxB?=
 =?us-ascii?Q?Dat2+R/MAujG0aceDqG0ONX5rRLId1FAxqlHRXQg/DwnJ0uxRE5adkCERyGt?=
 =?us-ascii?Q?eYEqJABMyZxa6uQe66+CmzeVzXkfwC7mNM/vw4WvSX8MJuKM4trrl7B5i73m?=
 =?us-ascii?Q?F6ZpjTd6A5K8OyeZvvIaiKCoRQDWuT0TkxJSljyLkzLMy+KgyEZicwU7/X0g?=
 =?us-ascii?Q?L4u5GmL4eir8bkYDIaOhEdsnUQuj1Gs4XzqpUBDK/cEi7kRtrWY3YOfWGJE+?=
 =?us-ascii?Q?cpjjuS/wKdr8EswtQp/Q7NgY1Y+qlxep8N9GXCjxN7gxVmv1Des+DlvC/+W0?=
 =?us-ascii?Q?9fkwFBOEv3wkK0utfQochq+KRGs1rN8tb8X2YcmSFDKrmg0x5N3Bj5HUGsqv?=
 =?us-ascii?Q?ErLMHlXPKhqM6sSp/50RGu0q1UM/z7QAnB98NUhNsJ243SiI3Ehp3ltHTl+Y?=
 =?us-ascii?Q?eAclQUNRmlBaVX/SjZTtjj51x+I+tCLAy8zxn0Y1sxT0aMd46yD9hD4iGTUT?=
 =?us-ascii?Q?v4aNC2/h70YiqQrpC99x0A4ppMg8l97l87l0lqdEzvsKwagbSOpSNWK2u3Rw?=
 =?us-ascii?Q?I1zKGAIBC5XEz7JU7cnu91+r0UrvinJ113Edh6q89jVINdwlqnF6lcnRosp2?=
 =?us-ascii?Q?Q6HouKgGqboSAFIzf4uiF1I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B579B582842EC243B6F01CBA769CEFB2@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59f5a52-8582-48ea-d659-08da68de5bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:55:45.9483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NYsJdj2Yy+ta8LihmGY/e83ALHjtnusggTaewa7oUIXQJs9N8swtMJ7HDmjFc0pf3BbUpq/QMOevSAEeKzxvYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1135
X-Proofpoint-ORIG-GUID: n6hhpIQgZ9AZnBfRQuNrNfLng_DdNKfe
X-Proofpoint-GUID: n6hhpIQgZ9AZnBfRQuNrNfLng_DdNKfe
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


