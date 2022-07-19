Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0458357A9D2
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 00:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiGSW2g (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 18:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240489AbiGSW2e (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 18:28:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24C15143D;
        Tue, 19 Jul 2022 15:28:33 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JI5Ev9007439;
        Tue, 19 Jul 2022 15:28:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=W5YC78LcAfVeK7rYiROmNXR6t8GNqpmGS37KZnqcWRk=;
 b=dSpz6D4udMFCz+ckEMVlpF4uqnCsl0LMRQxxJyw0k8UmOV+tbnibb0WI+9RbntbsNg6/
 pkIBuxpyojzdmMA5KoUPeEitl0sv45/k5Ru80n9wnGbykAoRIQuvWxePHgATwLzgY5Cu
 l8TA+D7F2KqeDkuIy3tNCGsW1TpdFIb+QlI= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hd7exk786-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 15:28:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZCg+QCMoSGj2hzPqCSqeIDmH0LjMm/rh2VapfeeBXS1dOy5V4oWnZaWqP9dLK9v2WbsbV6OGQPvIC/74dT12QV/D5+fCY4IjLdKNinehUYiKn4rAq0MzgfyT5UlouiVutxT/huE98n1R6SzfcBTW0mXe3tXHu2VBxC7MBJW7RRivNNNExiOMf1kSSaXW634e+OUbawzemW3boeFD/eG8B3EdJ8Opd5YMY4Hs0DepBEiRZcD2eYoKSrQe8t+54z7du+ZKO6dvu+cITfBZePbAeGXBbQBTlZiyQ8j87FEwJyEYdbLDq7EbwCixQOYnby2toMGM4+EP9tal6aU3rVcPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5YC78LcAfVeK7rYiROmNXR6t8GNqpmGS37KZnqcWRk=;
 b=mZW3ov/K3lyVtkucxydU/RPpJ5NkxaEWrds7jzdSCwT2Sk1Wxg3eYsamAGwHZuTpFiOx4fLdRu8vLj4YusWO0nEIN1orySIx6fzXTKuQhwc5838an9yZdwo+3FDQzn439k4jANfk3wYq/mff3GeiOPxn9bzpVjaS1g5FUWwqN1ycbZzIyqRWAEEmI5CamE/5hT0IK/DLuL07comBtOANzUaej4Jtv2zoBNDhpsHEh8nYJGkesZ1JKb31xtERXBZ2mtRDRHGlEKXafG+YRAiBhyf4GushlWcuvYDhxXr0lZCJTmdKxWcKDRW8ezcTtSGA2ideqmaE4/0rZ1la2pXUPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MWHPR15MB1549.namprd15.prod.outlook.com (2603:10b6:300:be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Tue, 19 Jul
 2022 22:28:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 22:28:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Petr Mladek <pmladek@suse.com>, kernel test robot <lkp@intel.com>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Topic: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Index: AQHYmmrwWVTrDYAzL0G5ckglE1ecDq2DvwKAgABeKwCAAD2SAIABrCEAgABCBgA=
Date:   Tue, 19 Jul 2022 22:28:30 +0000
Message-ID: <8A0701E5-E110-4DAD-9560-88FF87214286@fb.com>
References: <20220718055449.3960512-3-song@kernel.org>
 <202207181552.VuKfz9zg-lkp@intel.com> <YtVd4FKOcEmGfubm@alley>
 <9DAB0710-7D60-46AC-8A2F-ED4B8A1A4BC0@fb.com>
 <20220719143210.08f9922b@gandalf.local.home>
In-Reply-To: <20220719143210.08f9922b@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3785dc6a-d8f9-41c6-5bc5-08da69d601ed
x-ms-traffictypediagnostic: MWHPR15MB1549:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kxrMhjID1fgaVJsUI4mViDHJpBageEdPdL/p4vjNGNAQqJv5iqZsqed4Non5wSDtRTeeD1fqGCFhsvet3OmgpW1816ytaPT5dGNw9iSNZxmnFArmvXo3kBtBnfs/I6K9xz48cfv2zIwAsRZMnIDPezQc5V2GYZCOEX0Yl6isW0biZkYgxCUn2aIcfz+m5glR5GD6q9JxRr+/NK5c1sCdyZh47EKBE6KylXw0ywsi3oTMCdJX6D6fxxl8A4bkgftWZEkjQmEV3q7GSpm169Z7OwTxsTblTeB8rYJRclv+UOuJw2nQ6GdJKcNn8S9l9Bn/hMpaKrZ+8in/UTO4QxjR/pI09yx6NBrGwOQjsyXxbeqniDO2VeZ6BSDE6DHen4a5UdrD3dDi2GNqpOuqWN8+xhARDnqVN4EE7kBCVVtu10pFUpm5blYnpsCSQlbcgayfhwzo0wwBLKO0hKBp5Wy3OQ+Zs816sUJhWDWafMXkIYjv/tINs+1IGBirD6UXeP3/MmVim+PQ+bdfOo+RgmTvS/TazmxzDvirJ2jpj6HKqULGxJzpxvHwCf6n1Detca7xm15pnJa+VWT4s9ryR2eaI3t9Q5ghUzAw6GF5CjRSnXmtEbRPqiuGWUTQSRdJEDYINgpIo7tNVV3RfwCv21helUMZPzyx64tjqt72FzgPPueEjiUgxx4VT4tUcBTiMOBZLBN8QVMnn5LSK7d9pNwN1bip/sx6O5mWE4sWKYloPLCakJuGzMDF1pDQtQZL6zVcXeGCpwXMXrTBEg9b7WudePSo/MI9P4DATaDpEfE7++q9GMnWtahgo4Gy+IiMpN+1LDM3MUOJLugpMC+QypGskg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(6486002)(71200400001)(478600001)(38100700002)(38070700005)(53546011)(316002)(6506007)(86362001)(6512007)(54906003)(186003)(91956017)(6916009)(83380400001)(41300700001)(2616005)(8676002)(5660300002)(7416002)(66556008)(76116006)(64756008)(66446008)(8936002)(66946007)(66476007)(2906002)(122000001)(36756003)(33656002)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q62fPjwRWItS76Q8H45IrNRwbsSSIPctvJjacxf/4ERloIwqo/Tv68MDEhCn?=
 =?us-ascii?Q?rUaCszkda5jBw9hmSxMuEGn6KDDvfKN0gndVBQOKiO20o4oAGrn/GW7frp//?=
 =?us-ascii?Q?/llXdhDBquZrSsV7olIAvlfcOnMjnZwHQBbuAQGKZYelbqdhP8qXuv5zOB2B?=
 =?us-ascii?Q?3ZhIF7HP3fi7pfLILa6hnI1pu9a6ok0WkUKCnlEzJBy1tu3igNbS+V1N2XGd?=
 =?us-ascii?Q?+JPigLkgx+1yWFhXJPsb2iipOLMBI93XCvLSpwfuGTKme5AnFzIyFva+s0pd?=
 =?us-ascii?Q?R+cNEU3rJYdYXyb2hUHN1t4pW7OUbcmVr6B1z9VqzU+ElaaBEQpTkEtbZWc9?=
 =?us-ascii?Q?sOZ3FnKEBCe76mfMKkMjXLXmLKuJte196v8cgqD4cL/zFQt0Iihnutyix5dO?=
 =?us-ascii?Q?HtKq4L8vVW0ywudfYJ+PLFwYyHiivW3TyjEFZjBMYb/nmrDSnIH033SbTfaM?=
 =?us-ascii?Q?HAJSx7WInMdjuAc8TjfE/4SgVeaD0ZFlpxvXqXvmoV/d+umkyJ7EXko9Xwm6?=
 =?us-ascii?Q?aIJ8C/kITzxZTe3HZ6nF4KwAQluy9zlkviwdhW1dynpidPVJQXUs/n4ev+g/?=
 =?us-ascii?Q?FSCfZpGcc2PNVkXHDWj/FO6LoKKOsPZMIam9tPWNmrDsHvAF1bbXODg5X2nr?=
 =?us-ascii?Q?jpU9+LB7gCt4LqGamQNwTbfNqB6B00LtDSeF877PRqOyk+ACe58h/zMHzy3/?=
 =?us-ascii?Q?4AHcjTuicP0MQKy3ldSxfeNgQjxbcFWVTdeeYrgqSHzM0Kid3c4j2aeJKg3J?=
 =?us-ascii?Q?7pKfe+YXMDe/T5fUibahbzYLDgSvHa1953u5rghdK+1JSVJrigo2C3e38Z4a?=
 =?us-ascii?Q?NQ11ydfjdDbs23hjIK5ykA/bb9KHlfHWQ5X2WaGps7ANncWZwMj/BK4bXfyb?=
 =?us-ascii?Q?wdaS3ulFKfpFcDLkUI3L4YUgXBgJCTF4rNV12kkpSUZXNtyiPoZlyfQ2im3j?=
 =?us-ascii?Q?xvwqFMjxQPUJ+4+eVm89Y8zk/+xiIbkxjovg9ESpt/qV5TzQ71mYi2MC0lSx?=
 =?us-ascii?Q?xI8l8PSr1B7baxWMQ1xoIdBRWM8UxnS4GpwB0PEGtsemBi3t4kVEVDURMHZk?=
 =?us-ascii?Q?lJoTSv2IhmL3OC2Nbp0RcsDsEL5RjhHAkMsLhya5nQCkJcl40OrMIVC/eoMf?=
 =?us-ascii?Q?uODq+1SIOPcJuyIyPpaQL/zMCfDD+zXEhJOAgEa81176UmPKqzvskQHwr0v+?=
 =?us-ascii?Q?HxEzR0ggALdHu+v/ifCyoikq/JW/D4mhxPUF+I0eQJD/V7MUJxiCed8sqFOs?=
 =?us-ascii?Q?m7g13TL4pzeQ1r/0FeRGqz4Po1rIWbdKWKI7GJkANarVBEH+PtqyLlYbbIqy?=
 =?us-ascii?Q?cl9UMZsx7GShbiTRh5IVMARXTbyibUmvqP8Mm+OdeAEW4FPfv6pNQ7xGb+a9?=
 =?us-ascii?Q?JoCkpgG24NnveRYdGwZSOxHRFDrvZ6jKGXqHo7pSzpWBW0oQCGmvU1p/Dvdr?=
 =?us-ascii?Q?FW2N7PjMM+hPptI4y52XFtJhh7AEIm+1HvCvfF29nJsa3EGXxyOpdp1a9WTD?=
 =?us-ascii?Q?1Qj97Xy20MRgqnP2/LH5Uu/Gwh9AV3vLhyAFTcglCdJtL9wJ/ZrAdKlQtB9B?=
 =?us-ascii?Q?TP+OtCPXH7IJmbckZ2G3BSusLHewMRTd8gkkraGA6bOIG0muH1aGhMpghe+A?=
 =?us-ascii?Q?1/qBQVIoX1cApFUW+82zqoI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6635582B67FD7443A8D341E41B3F7D55@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3785dc6a-d8f9-41c6-5bc5-08da69d601ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 22:28:30.2284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MsGGXG90lwGA5BDdq44uhT4lHmZpA4DIARIIOt/Ev42uvK5Fb3vvCfFprRG0L9gXRVcWWJaoAyRR6Ezpz0v7YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1549
X-Proofpoint-ORIG-GUID: ZgVQf-gbvpAO586glCl6aEkY3v3X90Iy
X-Proofpoint-GUID: ZgVQf-gbvpAO586glCl6aEkY3v3X90Iy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_08,2022-07-19_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jul 19, 2022, at 11:32 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Mon, 18 Jul 2022 16:59:51 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>>> vim +/direct_mutex_locked +8197 kernel/trace/ftrace.c
>>>> 
>>>> 8182	
>>>> 8183	/**
>>>> 8184	 * register_ftrace_function - register a function for profiling
>>>> 8185	 * @ops:	ops structure that holds the function for profiling.
>>>> 8186	 *
>>>> 8187	 * Register a function to be called by all functions in the
>>>> 8188	 * kernel.
>>>> 8189	 *
>>>> 8190	 * Note: @ops->func and all the functions it calls must be labeled
>>>> 8191	 *       with "notrace", otherwise it will go into a
>>>> 8192	 *       recursive loop.
>>>> 8193	 */
>>>> 8194	int register_ftrace_function(struct ftrace_ops *ops)
>>>> 8195		__releases(&direct_mutex)
>>>> 8196	{  
>>>>> 8197		bool direct_mutex_locked = false;  
>>>> 8198		int ret;
>>>> 8199	
>>>> 8200		ftrace_ops_init(ops);
>>>> 8201	
>>>> 8202		ret = prepare_direct_functions_for_ipmodify(ops);
>>>> 8203		if (ret < 0)
>>>> 8204			return ret;
>>>> 8205		else if (ret == 1)
>>>> 8206			direct_mutex_locked = true;  
>>> 
>>> Honestly, this is another horrible trick. Would it be possible to
>>> call prepare_direct_functions_for_ipmodify() with direct_mutex
>>> already taken?
> 
> Agreed. I'm not sure why I didn't notice this in the other versions.
> Probably was looking too much at the other logic. :-/
> 
>>> 
>>> I mean something like:
>>> 
>>> 	mutex_lock(&direct_mutex);
>>> 
>>> 	ret = prepare_direct_functions_for_ipmodify(ops);
>>> 	if (ret)
>>> 		goto out:
>>> 
>>> 	mutex_lock(&ftrace_lock);
>>> 	ret = ftrace_startup(ops, 0);
>>> 	mutex_unlock(&ftrace_lock);
>>> 
>>> out:
>>> 	mutex_unlock(&direct_mutex);
>>> 	return ret;  
>> 
>> Yeah, we can actually do something like this. We can also move the
>> ops->flags & FTRACE_OPS_FL_IPMODIFY check to 
>> register_ftrace_function(), so we only lock direct_mutex when when
>> it is necessary. 
> 
> No need. Just take the direct_mutex, and perhaps add a:
> 
> 	lockdep_assert_held(&direct_mutex);
> 
> in the prepare_direct_functions_for_ipmodify().
> 
> This is far from a fast path to do any tricks in trying to optimize it.

Got it. I will fix these and send v5. 

Thanks,
Song



