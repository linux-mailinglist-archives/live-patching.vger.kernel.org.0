Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95855787FB
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 18:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiGRQ76 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 12:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiGRQ75 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 12:59:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC22D2A409;
        Mon, 18 Jul 2022 09:59:55 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26IGi21X024078;
        Mon, 18 Jul 2022 09:59:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=yXg6JjMy0R07mWI1NXny4Zx4zygxLLyoIuGq/LGc5v0=;
 b=JPFFdL03kbcyqdBbE/hDNf9Qqe9dRnXXLp7t0NnD/gSL38E3fHMM3kNKksW7NWkn7H/V
 fIY+9QhLU96OMqV2/wrM6pSer18VEF+iVaqJJmVezTwHQAF8rsQB9kUcbn9pIsYVRhH8
 OLDEqh+nKl1UzbTRWtwq1XoMEIvEOJTuHPc= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hbxbg9ryj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:59:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGrID8epBMr18SQYFiHXtP+/FAZpIal/VBan+XWDE2IdBt66XS69ynIqS2a6bGlizm5koPvuGAsMqVcphtcczarhH4d24fbEGUzn/10s7I8CQqRme2PzuFKJgXMA58i7NTTrotMbn6KwmEv2QufrhA5ixaBl46glSQqAncP0M9t6HONlgEIgc2Wb/3Tv3f/vNhvYTEFxrHk/WmASxpD56FoYZvgqfiEFt7Yl5gzjOAG9Blqtwygb3viX37kCsKEJwAiIogY5TlzWGxesu5LwmpQdZZnXOYohY82UFs7A+NxbyHEUd57+pa7dC4g9XZ3qzBzNvXGSDdeyYynetyc7oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DILsHDTmQWoQgf43l88XNm7Z0ZXncqbo+xf+O2O1wCo=;
 b=kgxr5Cus2Z/JabSpaxVPveyKkYICIuG3N0g0ar12Ym1V879pbbxt3vhamGYvALPKwg/vFt6OPmww97P2lR2aCljKdLmqCUzkGD6xZOdQn7wawzRwAhsDSD3aaHf1foGoNqqlapAH1ekB4jr90zK154GW0b7Alkd9xCty16E7c11Tr7ApR6xu8gW4C0fiyAXIRsoi3U+S37I7/7hr7KVwvysjOmFF05HLst1se5FG80ZwOFxwsNguDd7NCs+5X0fMxdOXN1yaHPs8E5Mg3kOsiR5Rc43u2QW1GlNF2UdtRK8pYl6f4Ax4vg++ineGqmnzDvndfdZ7dgbYiIzbYmY9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BYAPR15MB3480.namprd15.prod.outlook.com (2603:10b6:a03:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:59:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:59:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     kernel test robot <lkp@intel.com>, Song Liu <song@kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Topic: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Index: AQHYmmrwWVTrDYAzL0G5ckglE1ecDq2DvwKAgABeKwCAAD2SAA==
Date:   Mon, 18 Jul 2022 16:59:51 +0000
Message-ID: <9DAB0710-7D60-46AC-8A2F-ED4B8A1A4BC0@fb.com>
References: <20220718055449.3960512-3-song@kernel.org>
 <202207181552.VuKfz9zg-lkp@intel.com> <YtVd4FKOcEmGfubm@alley>
In-Reply-To: <YtVd4FKOcEmGfubm@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78bc628d-23a7-4ae9-30fb-08da68deee0c
x-ms-traffictypediagnostic: BYAPR15MB3480:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UZbscrrVTChwaTZFF1sUPIt9KF+1g6dCW1OOWspqbFOSVs16X+clEydNbELEuVN1UluNZuC25LkmKhL1dfkWBA56CWQ3VaZ9CJOpiWYt2sWfwL9t4XJwmkot052r9wKtkPDfhxY1jPE97IHz9JlBeL70FXknjPzVyQlMX/P6+IboX0j08VnGQ9l/KZ5UqUU+xUMFYaNUvWsCoT0gFw4xUsnJ4LePfOPr3BJVGcq1F6D4k65g3ox96YNcqojogieKaALXPiLszcMaVfK3g/kBAbOUVYKSn9bZNDeV0QTX9mTooF73G8colnXuyunCf1tHSQoNx1hF0tzlotnwiHTWIXV1AXp0P24G0sbievM7czoifaeGCWyioa/bTeNyTa3tmMHC3bsn9UTzProcR55dVW1YM54bgLqsV1EzVx18hEo3as6zhZbSBPIVOj/MpqKt0ZexqYs1JY/LwNhs+EEDXKgl4twlc7U9ZBeghJJ34PFaoKoiosO6OVDUAiCe7UYj2HrCOjTzYVY9wZoZIWHIIL8xds6Tht6KDTHz9il5jaYkX7tSKrOF6/oliJtgz2zHGBmwtif9HRSLyO2bjClGoU4rPeq/Fuv4bA1JPV6Gz+wp1aGDaD8ztIQsvgPEwuo6iU7ZMkAngEF5YMtc0ZWQoG4A1uN8QfBuV8IB+PDHCreIM+Aoc/2giJl54v/aSB7TfCYtaFW4yfGQm4N21S2MOKfquVXUBJJr0oGQyAU+7+E73htsYw1sq4DSjeuZbdi2dhe/MWebBzyjTOp2cLbY+Q4iV36+S8Gbrtp1jx073pzJ0nbsM841Ojelh4nG8ElxmoxWVTmcthzzNjdIs8C9XqAfr0mBKLHdaLQEBxGgEmrk65z8rEDpd4Pj2+CFZgNAPFTBjCpF8q9t4R8WVtuxkOYbk+/QbJTWzYRN2ya2KE0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(36756003)(122000001)(38100700002)(186003)(76116006)(2616005)(38070700005)(83380400001)(33656002)(86362001)(71200400001)(6486002)(966005)(2906002)(6916009)(54906003)(6512007)(41300700001)(478600001)(53546011)(6506007)(8936002)(316002)(8676002)(4326008)(5660300002)(7416002)(91956017)(66556008)(66476007)(64756008)(66446008)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4HRIsPxRx4vEFbSwFkZBP1F8l7h4e46FMRzl5rENmK5A8IzJIhB29jQavV1u?=
 =?us-ascii?Q?nJpFO6drRBonP110CE8mDPcGZtDM9sQOHnVE5dDBH4styiMfbpWlaDSW9HP3?=
 =?us-ascii?Q?h4p/Tk6G7FKBBDJ6vQ5F+UknV645qGPYI5MpvqVwepjDFS7Bc7uLALPHYd+I?=
 =?us-ascii?Q?myO37jpCBlonJNSkzLFbSviN1BUfx0UPEr3NBsotlTPRzPNw8HoC73qsA3LC?=
 =?us-ascii?Q?mBnJL4KD6NRIT4eEV6oe+BwxZjGPZ5A8+6CEJRCfb5xlTqYQz1vcvRpPl+E9?=
 =?us-ascii?Q?3tlSzHD7jbRuk0OdSodCn9s0ZqZWEX9V3ljX9K6zRyrVVOZKdeW8I1HQmOH4?=
 =?us-ascii?Q?vo93zvAWkzzIGwBrDvgwHKTwnx7kkUmsAlGTjV24I9MSKbwJDugHIPjcDZrY?=
 =?us-ascii?Q?PhGNoU/H99SLmLDVYvywHgCAWvmvY0M09EKc8zztG7HwnzMiJHJGeL0mkoLq?=
 =?us-ascii?Q?GdtaGgsBsA9NVsjWvg2NKCiNQe/afOrNbP0P54U3axlZ7Y1eotBk82trX11+?=
 =?us-ascii?Q?iz+ICVkwWSULWui/zRSOlfUa9xFITRx20GIvD/mwvnqELmYoBIyt/ka9Duol?=
 =?us-ascii?Q?jdwNNGvbtgY8EdJPPY9rXlTWD+rNz998ROAV1w6oHHDj2d8TiBt1eG8Toe1P?=
 =?us-ascii?Q?y9zSGIVbVpPENi6+9juimtuiE9XHnvoIPM6jq7i9SKpwvG96W8HIykycC/Kv?=
 =?us-ascii?Q?je5ZfWQddNnoFtkiHuX1ep0VRq3lYU6fRkm0BSWXP78bUlHv/+00V6y7gkYV?=
 =?us-ascii?Q?dlI+/+IYrIuVE9by2nw1nPUwlR5grtTJnit0CPOO+X014EJx9aH4vqja0MGX?=
 =?us-ascii?Q?puG3CPi6OF/BZ5Dne9lUUWq+Kgkx0KAaRuORXyP96V/dqKbwcP/wFSdxc7+3?=
 =?us-ascii?Q?HzrCDnpO1cwXnqRVmxHTAP9Ok5t4LnMiHco3GthyOA8qQa90gwmAQ0KHzg5W?=
 =?us-ascii?Q?KmWcxiI0Pz2EVpW3S+CRsQMi7V9AI9p4o72pS9ZFy3XThUGmR9a/4hPUrGER?=
 =?us-ascii?Q?01TklhZK9sUtPVI3K6nMRRxtxEgFkTpbk9FvEJmGytxJmfbP/c+s+Gm1BUM5?=
 =?us-ascii?Q?NKCncnoNMA5cJRxOXaJVSsnqyHj55heZXjIsFMTFf418ocqciBLSOJQrwQJR?=
 =?us-ascii?Q?awWJbMATsnKHwjfuO1HwUMzwdDlwyNbg60JpulgRf8m84gFs82hten0L1Rxs?=
 =?us-ascii?Q?GWtpdL2a1A9bUvnz+37lCikRG0ypT+E9/Veb77orTjTLY+xxTY/kN0TMFeH9?=
 =?us-ascii?Q?hV7eJr6sNYJe+EXf7oQ1vl6QHeK3JfUvMCFjUMx5ItuPi/+36jVaqV0yruVc?=
 =?us-ascii?Q?6MGxQ6ZhMpboPGyIWQh/hjuEoDawe7Fp2xl15jW618kpFMNEMPGYV2nQByoJ?=
 =?us-ascii?Q?E6QmaakZ516rYEqN1pyhc1kxHH81w1rjcnEOa4uKSmjKvJnK0OFiHQyeciC4?=
 =?us-ascii?Q?8B/VJJp2Et+CoBv3BhuHaMZmiMFn5R3qROGWR4k20wG6+EzJ8JcljBrAw/P4?=
 =?us-ascii?Q?mWtAEuQS4HEamTBRMU0r2XvfUJWO1Mfh0kW8iSzYluhcuGkw5PwdB6lNllNg?=
 =?us-ascii?Q?gKmLFd4zUFhDMmbHn781Exv2tXc00Epsnjp1x73xKbuh96Q+KOBzi63C9VAc?=
 =?us-ascii?Q?xrOHdHwWrYAC/TsE1pv+Xpw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5432BEE94F42FB4DB6B00AACF6B5C339@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bc628d-23a7-4ae9-30fb-08da68deee0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:59:51.1838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lYKkbhgnQ8YCik8+gQSp/wP2VETB07bY1uB3Rf8Y4gHaTLA0FswQq4XrWXEG+IiiddZ/hnB0Bw7snk4XYIReaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3480
X-Proofpoint-ORIG-GUID: B7XsIwzn7mnmSqeepSTUN2orJ2LuWfOS
X-Proofpoint-GUID: B7XsIwzn7mnmSqeepSTUN2orJ2LuWfOS
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
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



> On Jul 18, 2022, at 6:19 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Mon 2022-07-18 15:42:25, kernel test robot wrote:
>> Hi Song,
>> 
>> I love your patch! Perhaps something to improve:
>> 
>> [auto build test WARNING on bpf-next/master]
>> 
>> url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-135652
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
>> config: x86_64-randconfig-a004 (https://download.01.org/0day-ci/archive/20220718/202207181552.VuKfz9zg-lkp@intel.com/config )
>> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
>> reproduce (this is a W=1 build):
>>        # https://github.com/intel-lab-lkp/linux/commit/9ef1ec8cb818d8ca70887c8c123f2d579384a6c6
>>        git remote add linux-review https://github.com/intel-lab-lkp/linux
>>        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-135652
>>        git checkout 9ef1ec8cb818d8ca70887c8c123f2d579384a6c6
>>        # save the config file
>>        mkdir build_dir && cp config build_dir/.config
>>        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash kernel/trace/
>> 
>> If you fix the issue, kindly add following tag where applicable
>> Reported-by: kernel test robot <lkp@intel.com>
>> 
>> All warnings (new ones prefixed by >>):
>> 
>>   kernel/trace/ftrace.c: In function 'register_ftrace_function':
>>>> kernel/trace/ftrace.c:8197:14: warning: variable 'direct_mutex_locked' set but not used [-Wunused-but-set-variable]
>>    8197 |         bool direct_mutex_locked = false;
>>         |              ^~~~~~~~~~~~~~~~~~~
>> 
>> 
>> vim +/direct_mutex_locked +8197 kernel/trace/ftrace.c
>> 
>>  8182	
>>  8183	/**
>>  8184	 * register_ftrace_function - register a function for profiling
>>  8185	 * @ops:	ops structure that holds the function for profiling.
>>  8186	 *
>>  8187	 * Register a function to be called by all functions in the
>>  8188	 * kernel.
>>  8189	 *
>>  8190	 * Note: @ops->func and all the functions it calls must be labeled
>>  8191	 *       with "notrace", otherwise it will go into a
>>  8192	 *       recursive loop.
>>  8193	 */
>>  8194	int register_ftrace_function(struct ftrace_ops *ops)
>>  8195		__releases(&direct_mutex)
>>  8196	{
>>> 8197		bool direct_mutex_locked = false;
>>  8198		int ret;
>>  8199	
>>  8200		ftrace_ops_init(ops);
>>  8201	
>>  8202		ret = prepare_direct_functions_for_ipmodify(ops);
>>  8203		if (ret < 0)
>>  8204			return ret;
>>  8205		else if (ret == 1)
>>  8206			direct_mutex_locked = true;
> 
> Honestly, this is another horrible trick. Would it be possible to
> call prepare_direct_functions_for_ipmodify() with direct_mutex
> already taken?
> 
> I mean something like:
> 
> 	mutex_lock(&direct_mutex);
> 
> 	ret = prepare_direct_functions_for_ipmodify(ops);
> 	if (ret)
> 		goto out:
> 
> 	mutex_lock(&ftrace_lock);
> 	ret = ftrace_startup(ops, 0);
> 	mutex_unlock(&ftrace_lock);
> 
> out:
> 	mutex_unlock(&direct_mutex);
> 	return ret;

Yeah, we can actually do something like this. We can also move the
ops->flags & FTRACE_OPS_FL_IPMODIFY check to 
register_ftrace_function(), so we only lock direct_mutex when when
it is necessary. 

> 
> 
>>  8208		mutex_lock(&ftrace_lock);
>>  8209	
>>  8210		ret = ftrace_startup(ops, 0);
>>  8211	
>>  8212		mutex_unlock(&ftrace_lock);
>>  8213	
> 
> Would be possible to handle tr->mutex the same way to avoid
> the trylock? I mean to take it in advance before direct_mutex?

Unfortunately, we cannot do this. ftrace code cannot look up 
bpf trampolines without locking direct_mutex. 

Thanks,
Song




