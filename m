Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B2757AA15
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 00:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiGSW57 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 18:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbiGSW56 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 18:57:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FB162A5C;
        Tue, 19 Jul 2022 15:57:55 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JI5AHD020611;
        Tue, 19 Jul 2022 15:57:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=6i1/Yjzvea9sZyTmrcHQINsckMRJy6koL10j8VZ/PFg=;
 b=HB9Cap4ZwaOK7SZW7e+jyQJ00fspxw/VkCsmgq1ksg0HNl5qrhBdt32mWOtrwLkbMhsb
 ehU8Y0Tz4BYCarnIl2SJOWl+3kmbKYd7CgqwUSLFfE6qMDMYhY9FwEUF4k7rQbIOl1uG
 0JY/cxKhU7OY6ICTsBd9RDcwThqqu9xUINg= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hd974asbu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 15:57:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAkFSgI0YRGwr0Nss/aQV5gIBK7sGc72/IMBhA9TVPrGnJeBORp6emnxolioKCc6PwRhYnY7oAOrMHadSCxjdIjMyYQ6FyW0teXD7Xr8Bi56h5BJCgkxBaKseN8Y9Cx4zOiJjR0sVnJchloaq4FpUf74iYgJ/uDdVZ8t+kRfxNhbI9DxAX7pbln8kQq8QPSFapXjlJFcWUJJSRlhvOiJaTySRvU++xEdYhKm9RSZmTOj8y68oSHDhVoIZB6CXqqwt84fsTH/yqw/yt92/G2AdboNPk8dVtEn+Ng/Kee14vXf8nrEkvibmbq/AusnGehyan7kGJZi8y1MPkG/5dDPqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6i1/Yjzvea9sZyTmrcHQINsckMRJy6koL10j8VZ/PFg=;
 b=KgMOrcte6xKlwqrMSxG5hnJOZnSkEzU2rObqt2B9r2JaRuPM848Q7uxjBd2/wuM29H0Uynq+Z8s6j3zC5qF28VAoXwD5V4XoQFsYgZjkWfuIyEoJ6ZBPgdjMCvcfBRFkJ5jHhpjX5eAw1HnU4XqNJjlb4HDzrDto6/rhvgSNk95+SwaOl+4Jl1DNXBYFc/dmQjxMPLcYAD/gcbUJRoYRMxGZIpN1cAhwuNJq+ex1IE0OKNxYRGTX3fnwySosdb7HytWTt5V37rLcdPkG6hQhbU1Mm02hgRmqrFChT7OneTqR7uQ3ULCTyf1OCIHtOH8uYJP2lQFOT67wdLR2cntzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB4632.namprd15.prod.outlook.com (2603:10b6:a03:37d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 22:57:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 22:57:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Topic: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Index: AQHYmmrwWVTrDYAzL0G5ckglE1ecDq2GBfkAgABLI4A=
Date:   Tue, 19 Jul 2022 22:57:52 +0000
Message-ID: <C6229252-B41F-43B9-BABC-538947466710@fb.com>
References: <20220718055449.3960512-1-song@kernel.org>
 <20220718055449.3960512-3-song@kernel.org>
 <20220719142856.7d87ea6d@gandalf.local.home>
In-Reply-To: <20220719142856.7d87ea6d@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e54d0753-00bc-4b99-ad30-08da69da1c50
x-ms-traffictypediagnostic: SJ0PR15MB4632:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DsMN616oCQBmG57kiA3gE4BgGnZT64gAzqBUzVzO1KkHtFoZdpCJikSJt+ZyXJFS6B7pEKeL3nzUbQ0eEpf/ucD+7Fky6Nl9/3ywus+Nooxhpnm6TqEJWjFjq2ek5RotnvSPRY3ospRimUXcNCOZ+wWGNgiDrDD9NzDiER8LuQqFULhzvSEaVn9OHYNT+DgjLgV+n0J0kSSzmi0d7m5i5ED7GAfRuBA8fzk4A7miLDbyGK0TTHacE9ssmdaeGJLsSmjjT1cS7novtymhjPzPNomVFiwWOmRb1opHrVTt6EKniLcDPxoTSlFs0RJbEKJCs09w/DNpZfoaIWVsXhpceUfmPwjaxRSGda85575NzPjzdDgrba3ZL2uEtQ8LZSzKPmJ8o+11IB+Dk+1tGkonwlqSf1nazSHbMYRZO9JUpAll0YbeAM+8NbPoc/jzclOpD2fLWPP5/o6pIcq5GN+SUA26oy8WtYqsAcCjm2gj2CEdfUy+fYwRAlJSuLe2S5Yq4kCQzOovq54JtQejq2Ilt4MFU1tQ0nRaHIeVQqqPr+Hxu912fol/BrrW2xaV+Loj8f6ZQJ/1kooPRRwVLODZAhRCqLCKSWkI6YhuCT+210zk3qwLsRZMTW9GO5ZNXO8WKmNBaVJjR8XtIQ1uQmBPNlRzzHbA8MgV/y30NTpMHHo+UBKMd8cDGoubrN8uTG3hD6wuiLeltWodCqmVuEMS9mQyecCNioRCtxluzRBGxSiVf2PVMMyAGqZHO6E41PgmTnaKioWZ4BIL/ZG231SBMjBaaQP0eavmqUj6QLfYVXDWJtGAux+VVhXuNcm0wbZPL0VxshMVveZAvdcOnSknpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(83380400001)(71200400001)(41300700001)(186003)(478600001)(2906002)(6512007)(33656002)(6506007)(53546011)(2616005)(8936002)(6486002)(54906003)(86362001)(122000001)(6916009)(316002)(5660300002)(38070700005)(66946007)(38100700002)(8676002)(36756003)(64756008)(66476007)(66446008)(66556008)(4326008)(76116006)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l4i7trkRJy1VUTyo6yLltAsFezJ5/SLMoDe/NMkwNag70jwg5j+jcDASrq4v?=
 =?us-ascii?Q?g73GyuYPrg/8KzP4yRU4zsynd/I7WqBFfZE+vx3DrcgV1rTRimAjXPMg0w09?=
 =?us-ascii?Q?3/R/3kv7jYN37JCYTBbkj3ywCHL7y0sWuBWHakZ6DE8Sxk4OqPK4PFan0Tp5?=
 =?us-ascii?Q?dL5pc3GdXAHyaodCRs6X3WX/zs6wUoEDH6pR6dwtnv0eSBY5byGbzS64wCZt?=
 =?us-ascii?Q?G8SKbkTjabxRdkWZqiz3lmjkunhAi2ZxWOnCcQ/LDmwm8Q830kZ07GfCVOVb?=
 =?us-ascii?Q?kYYOru/7uBlz9Akh587R64pUy0PToz4NzpMjkUxGGLyg+6UvviGlTYvLhaJP?=
 =?us-ascii?Q?6uLpAU7OgrEiMLMhDeyiBsrDdCBa//NOhe5UdDipE6kDrvebUdWVmKQjZY1a?=
 =?us-ascii?Q?92AAZ9ebdI+GQBXgGcIVl+3JhOg9C49X8oQ+U7HrEJ80Ipxj87Rk0dAruQkr?=
 =?us-ascii?Q?tCsMT/EGXi3EesGrh3J4jkjd4PSupX3dB9s7O4oCSd3ox5m7xBMbVBHCxGUZ?=
 =?us-ascii?Q?vSS+GjBPUrDGxZ7YLxqak78YXNW2yBBo6cKlFj/qjGGMfbtEGrlBhKDUMMZh?=
 =?us-ascii?Q?Prk9fqw8ExkrB6FwrT2iiCIyWJh+z67LT3KlmVFXOOBiQ6TaO2m8rwg6CPL1?=
 =?us-ascii?Q?bxCaeSLCAovC9MGaSz1qMKSMHj4l6Nq+luoe8lNlbaq/MTdA6S/9zgQJAtJc?=
 =?us-ascii?Q?WwrUqLLqhWIPPeXjPoTUL2yCZt73cOCR2WqClOgW0hQ52Ioc1z5O3vlaybC6?=
 =?us-ascii?Q?oVBHZ3c973vMOr0HZlny1/1Wq1YmD/XwetkgNtyh5XuhFlb7Gat+6mLBFKVk?=
 =?us-ascii?Q?C5wVmKNpxETI2O9sSC8NTgwu19Mu7W5ksQSxCqp/9Nb2o1hGNUd8X4EPDuk9?=
 =?us-ascii?Q?ueJggb1Jb1NPQlnGDvyzQh6PWWKOgwrrdwpw1TpNdvqRqSz+C6JZ3ny/nGSM?=
 =?us-ascii?Q?0xTCuyWgYsXIJrPERy2a40f90H3rN9g8zgk80m/4Z6ZiOShXWpmy7005WX40?=
 =?us-ascii?Q?Rh+/bCCCQbOH+lXh4RLdfrEcqVXehU/92+zA6a4yitD5vZ/DekqzLS74Sqks?=
 =?us-ascii?Q?7ckIOyuI+v3xTDvQQ2zBR2bi1lWByjsBMZqE1rwbuejA1VCdBckwRQd4AyUk?=
 =?us-ascii?Q?VOPkQ+4nuawr7ISoZVZn7nFRoRty6ks0vapB96wuZJRV2T+ydZO4942WJ/Mc?=
 =?us-ascii?Q?3FOCzhGzl0PbHuuHQebbPXuTIxBdZkGRZd6Dm6UuBImMABYGp7xN9yYRYT3y?=
 =?us-ascii?Q?shmIJlDZ1t2d19VcyF6iz6VfL3XKWjIXs1wcRqoDEouA9oV+tLn8kPmZO4kW?=
 =?us-ascii?Q?xj7Wy9MJ3RB2tEiDCSv43dcLom38/n6Xee/2KSKgLYsDcmUinjdNvyik9E65?=
 =?us-ascii?Q?V8jR2TbIY5aYsVV8rZh2WRs6Sg45skWjux2hviPMN8CcCZbSErBBvTc48gQd?=
 =?us-ascii?Q?EUzKWXdJcN70iq5/NLJcihCk6pmYHz6mAYDU630nEUliw06HgIhc5jc/K8Ua?=
 =?us-ascii?Q?3QRdo/0WzS47FLu7tJehTYqLAb7gLyGUfpoi95lBUFPqTmqcFYGPKL/CfoZ8?=
 =?us-ascii?Q?r+hXhBxdOG8DB+byhlf3Ni1xvanAIiTwnZpUHX3QAd3fhD0j+4cUgze8j5Sg?=
 =?us-ascii?Q?mdO+qpOsw3Kqk/BrlTWBI9Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0FB8228F3C90C468745A56B944765D9@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54d0753-00bc-4b99-ad30-08da69da1c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 22:57:52.4869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rt+3zlCw8vCisOebjV1kDK9cx11kCNFUtHQkbCRYH5F9uAHsn1l+G+5lj1cq/z2bRWPgCOWY1d/nJKkujNLz2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4632
X-Proofpoint-ORIG-GUID: mEbU5ll4ChLZRZvr-a23lNhm29q9qCTY
X-Proofpoint-GUID: mEbU5ll4ChLZRZvr-a23lNhm29q9qCTY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jul 19, 2022, at 11:28 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Sun, 17 Jul 2022 22:54:47 -0700
> Song Liu <song@kernel.org> wrote:
> 
> Again, make the subject:
> 
>  ftrace: Allow IPMODIFY and DIRECT ops on the same function
> 
Will fix. 

> [...]

>> +
>> +/*
>> + * For most ftrace_ops_cmd,
>> + * Returns:
>> + *        0 - Success.
>> + *        -EBUSY - The operation cannot process
>> + *        -EAGAIN - The operation cannot process tempoorarily.
> 
> Just state:
> 
> 	Returns:
> 		0 - Success
> 		Negative on failure. The return value is dependent
> 		on the callback.
> 
> Let's not bind policy of the callback with ftrace.

Will fix. 

> 
>> + */
>> +typedef int (*ftrace_ops_func_t)(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
>> +
>> #ifdef CONFIG_DYNAMIC_FTRACE
>> /* The hash used to know what functions callbacks trace */
>> 

[...]

>> 
>> -	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
>> +	is_ipmodify = ops->flags & FTRACE_OPS_FL_IPMODIFY;
>> +	is_direct = ops->flags & FTRACE_OPS_FL_DIRECT;
>> +
>> +	/* either IPMODIFY nor DIRECT, skip */
>> +	if (!is_ipmodify && !is_direct)
>> 		return 0;
> 
> I wonder if we should also add:
> 
> 	if (WARN_ON_ONCE(is_ipmodify && is_direct))
> 		return 0;
> 
> As a direct should never have an ipmodify.

Right, I will also remove IPMODIFY from direct_ops:

@ -2487,8 +2490,7 @@ static void call_direct_funcs(unsigned long ip, unsigned long pip,

 struct ftrace_ops direct_ops = {
        .func           = call_direct_funcs,
-       .flags          = FTRACE_OPS_FL_IPMODIFY
-                         | FTRACE_OPS_FL_SAVE_REGS
+       .flags          = FTRACE_OPS_FL_SAVE_REGS
                          | FTRACE_OPS_FL_PERMANENT,
        /*
         * By declaring the main trampoline as this trampoline


> 
>> 
>> 	/*
>> -	 * Since the IPMODIFY is a very address sensitive action, we do not
>> -	 * allow ftrace_ops to set all functions to new hash.
>> +	 * Since the IPMODIFY and DIRECT are very address sensitive
>> +	 * actions, we do not allow ftrace_ops to set all functions to new
>> +	 * hash.

[...]

> 
> Again, these are ops_func() specific and has nothing to do with the logic
> in this file. Just state:
> 
> * Returns:
> *         0 - @ops does not have IPMODIFY or @ops itself is DIRECT, no
> *             change needed;
> *         1 - @ops has IPMODIFY, hold direct_mutex;
> *         Negative on error.
> 
> And if we move the logic that this does not keep hold of the direct_mutex,
> we could just let the callback return any non-zero on error.
> 
>> + */
>> +static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
>> +	__acquires(&direct_mutex)
>> +{
>> +	struct ftrace_func_entry *entry;
>> +	struct ftrace_hash *hash;
>> +	struct ftrace_ops *op;
>> +	int size, i, ret;
>> +
>> +	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
>> +		return 0;
>> +
>> +	mutex_lock(&direct_mutex);
>> +
>> +	hash = ops->func_hash->filter_hash;
>> +	size = 1 << hash->size_bits;
>> +	for (i = 0; i < size; i++) {
>> +		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
>> +			unsigned long ip = entry->ip;
>> +			bool found_op = false;
>> +
>> +			mutex_lock(&ftrace_lock);
>> +			do_for_each_ftrace_op(op, ftrace_ops_list) {
>> +				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
>> +					continue;
>> +				if (ops_references_ip(op, ip)) {
>> +					found_op = true;
>> +					break;
> 
> I think you want a goto here. The macros "do_for_each_ftrace_op() { .. }
> while_for_each_ftrace_op()" is a double loop. The break just moves to the
> next set of pages and does not break out of the outer loop.

Hmmm... really? I didn't see it ...


#define do_for_each_ftrace_op(op, list)                 \
        op = rcu_dereference_raw_check(list);                   \
        do

#define while_for_each_ftrace_op(op)                            \
        while (likely(op = rcu_dereference_raw_check((op)->next)) &&    \
               unlikely((op) != &ftrace_list_end))

Did I miss something...?

> 
> 					goto out_loop;
> 
>> +				}
>> +			} while_for_each_ftrace_op(op);

[...]

> 
>> 	mutex_lock(&ftrace_lock);
>> 
>> 	ret = ftrace_startup(ops, 0);
>> 
>> 	mutex_unlock(&ftrace_lock);
>> 
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +	if (direct_mutex_locked)
>> +		mutex_unlock(&direct_mutex);
>> +#endif
> 
> Change this to:
> 
> out_unlock:
> 	mutex_unlock(&direct_mutex);
> 

We still need #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS, as 
direct_mutex is not defined without that config. 

Thanks,
Song

[...]

