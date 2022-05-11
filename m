Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35C7523A67
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 18:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344730AbiEKQeD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 11 May 2022 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344807AbiEKQeB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 11 May 2022 12:34:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA1B239D94;
        Wed, 11 May 2022 09:34:00 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B3LDd3003738;
        Wed, 11 May 2022 09:34:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=qss+fz2Iv8k1BvP3RYr9rHnsG/RDcgA6xAS3/Ne9wFE=;
 b=OZ3lqTraaG4qRCb35uXSdIk9FECbzr+CEFipbUgXd0KjS92Wn5B9w1QtnSf8esBJVbFK
 fxi7wvVSem6Hv3w0O+WtMccbUr0Tmb0yo8uBlQPDr+EAfqpfad4OdTST6KLLaMjOx4jv
 4flUJq6VBNly8RWPlSOrzQ7dsCpl5jbXG3c= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g055hku71-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 09:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJZY+ornGq4ln2/1I8ZmRlkEbSdft4Ezsm5PE7+Qrq4IekKoMZIn03LO6Mdfy62R1HfkoNjZFHjrQSUqHJ5/qKqSZkkRG1IzKEJuFby+F7KyOaGB4K2MXTCe9/j+jgQMD1nf5PynsszAAuR4HyRqQW9FSa3NekohbkVvaspACmRcyYu5pp0/RGNvccLgReDcL00DU4UiUiE0AoL5nuKHV6IIokN3B9XCc/VIPvQDn+AFrRNRIKqjlhjStbsj0q1xsxjQEmLWjyb2fm+a6Y+rNR8VvZUPUKMQ4e/SCv5lh1xViRX6eDmDuvNMfEaGGuGPQ5Jz/ukM3O5oJAzWTe49+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YuFjK6ZXHQZzzwa+/lxaV0kv7dWceUh9RFMYsADf9I=;
 b=h1OF5AefyHqpvu316zEmLMNFNoJBbtHE6lcKWfrD1ZgIJirZpGa7z021UcjTHYMIcAxwoXW7vt3fWeW+FK0cTodOxX/yRTgwUYLLMzSFA3gOnRPoYAhTohiY7fS1xRNUcekLBTBlsuj94wym/gRPS4wBGUf8aMeVKwKH+Y5JpGAfZlcJcMc1dZDGtvnKP6Mh1tV/27SWDjusdpPVuCWs2wyRq0hBBuK7j4w7nH/w2Uy1SYioGxFeUKwLte+FwGOT2o4GwetMmJq3dgGbiKvyk3Q6uf62CKbIAnpUaROeSZ/cvvIH7hTppl5B1K9WN0BImUz8ipCeY3X4bqJnUsuYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1148.namprd15.prod.outlook.com (2603:10b6:3:bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 16:33:58 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 16:33:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>, Rik van Riel <riel@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsu2JIKZQIXUOp7t0Qujiczq0WqGoAgAAU/gCAAQUkgIAAXf2AgAAkx4CAAAZjAIAADJUAgAAUwACAAAnWgIAAEcOAgAA3ZACAAA7PAIAACjGAgACUX4CAAHf4AA==
Date:   Wed, 11 May 2022 16:33:57 +0000
Message-ID: <78DFED12-571B-489C-A662-DA333555266B@fb.com>
References: <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
 <20220511003331.clfvwfgpmbr5yx6n@treble>
 <20220511092433.GA26047@pathway.suse.cz>
In-Reply-To: <20220511092433.GA26047@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e148d220-6efd-46d6-39dc-08da336c0c31
x-ms-traffictypediagnostic: DM5PR15MB1148:EE_
x-microsoft-antispam-prvs: <DM5PR15MB1148949382F7207A0988D082B3C89@DM5PR15MB1148.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TzYuDA5D4ZoRKuaCYdZ02P3f+dncxZieyIWIWxI2Sgnvr2SMpJ3pTz5G0okNKwXVqj6CmvEFHmcmG70eDhRjuiP4d+sJjZkJc9TDClEnUoPUXmC4R12manj+TPsfMVIQYMA/q4vpeeW3Gi4hRVYeeK5a3BOZKdCzz4X1N+GR9f4Khfiuspq6rkLKj7pA7LM/z+3ohQ/ZiH8XSvFUT1MiiyF1vsvtNTJxP9pqABdVG3w4OwbGbhOCAi4ANEtteQ2eRc07cBqcioj2x+wDUlKSaCFp9lmprQSCtGxl6hUNklvkhaB5kefd3ycesGP/fa7/9039Y2x2rlbwgxJ5OHxupkduL/fgvjb+z9VqdRnr94eBtXpgYlSQWQDJaaLWKTciyZvBBZlzJn5sRKeG9VmFMpJNu4dmDAHIVBbkCWRXFeFaS+N40ZYfKzk+LFCzLOuR5bVkozbBBKPeGItfNZfmXPZvQ4twnSxY9zoGtCXv6v/r1pp7cIhP95x/huFIlfO15QTVQoQILKP/jKJ9KeK+bAq5GmpqY1SJQ7nlV6supAad+1ULbwkLsiPQ2vvUJ0nbpsZjB6ZhT2dDtbiwoFDA3v1tD8ipZMFBIlcK1PqN8uzNW1+YIZWZwIUtgqJCag/krZdsrjGjFLczE59R8mwKCGxdct7rEcN2n0Q7PJ2Dpvfhkijk5qGSS8gmQjuckxQhB7Tgh7m2K2GGlDlzECVkeWkrGtOZ7oAaGzK0d3xAnZWh4oAuxSm+woONmZ3iol2u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(6486002)(6916009)(54906003)(33656002)(508600001)(66556008)(86362001)(8936002)(76116006)(186003)(36756003)(66476007)(316002)(38100700002)(66946007)(38070700005)(91956017)(4326008)(64756008)(2906002)(71200400001)(7416002)(2616005)(6506007)(6512007)(83380400001)(5660300002)(53546011)(66446008)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?10tLzeD56sHTQp1GnqyCfeQUmTc1UYQLJ69XKjok1nhZB2DadgSqyxbbw8p5?=
 =?us-ascii?Q?5EutBmfW7g7poZv4OMBoAY1QO+RMyykM7n8GS5eGaR3/HICana3ToHAQntGY?=
 =?us-ascii?Q?Cg1ow43dUuX/3MsmD1MP7NFz1vqxuA/Qlt3TFqunKR14tlhSJ03ORiBm3xVZ?=
 =?us-ascii?Q?j7hcWLXMhaeTMOUv9CqS4woXR4hPBDBfwF2POyJEyv08QP4V1HW1y3ZsoSO2?=
 =?us-ascii?Q?dsUB+u5iKEu63XPA+XJDICU8dQCLDD42/WsaBIDEzIKz5vd5On/ObIkOwA5t?=
 =?us-ascii?Q?Y/8vTn0f4J8FABztBv+DZngNWgVH+GtJDKEmIYu7HjBTzc1XpiolbbS8/JAl?=
 =?us-ascii?Q?fMSTQU+CUCeJl2lO/KfDL8izrzlEiR3oD4lMl6gO6qaSGZZlofZTrdGoLIcz?=
 =?us-ascii?Q?pzJLrQNa7GM+ZSTipZqzoVcOr6RGu4oiXLvpQ3+7Cd2EqnATuvCMdmYoSX5e?=
 =?us-ascii?Q?UBUxyXv22Qs2vV4AtXkTjwmrK3h+CveAHklGONTPCaNqykdoyFp3X1ImO3w0?=
 =?us-ascii?Q?FjJ9Z+4KzDv4pc8jYhm2ZozAx+jl0wF66Q+tWlerIlyHN7H7Cc2VUMiyx/eN?=
 =?us-ascii?Q?hpfY/r3LkjZu8nA1ZDxL50L3lzlySGyBpC23FZBi72umiFd2VcgaN7gNdACn?=
 =?us-ascii?Q?YabpYPBM8TfDPJTH4BCFPQLmyNWdaICH4CIdhhqxNnBE+5AcxynjvkMzQv+o?=
 =?us-ascii?Q?nlcIHXkspS6Jlm7m2Q82QuSo7x/xhWrFYaUrXQ0nmqo2nYI/gE18xMwQBFey?=
 =?us-ascii?Q?q9GcNEU4iRVfsSaTJmkIyYruOXLNUver2OXnw1/YxzX5C9hRNmoMmLe3EoPB?=
 =?us-ascii?Q?k9MHiZ/snlqGweVfQKFw3CqfjPetJbDT47djKRzbbOtzkGqHgIYy4XSnreIK?=
 =?us-ascii?Q?uplV6B/dbFuPEgVPa9ABw+yhDINrXRcUCD39nfGs+KVvrRuFemp/VDpWC/eC?=
 =?us-ascii?Q?TQP53VhVD+rl6A5/87VHrJOPOt6WKv+JABNsVvUIEwVMCuFI2C9niXwbzX4k?=
 =?us-ascii?Q?siusf/yQkMbts4h9BUd0mPLxX0zVpgYG7MyPpLNJ/YmRn/G/UJP3PRe2w06M?=
 =?us-ascii?Q?XQgVXWp9ycmgUfH3OMJP23LKYMyOZw7Yvb+JUcGe1new0h+TSGx/6Fo+8kRY?=
 =?us-ascii?Q?yl+pKGF8EZz1ZdGGNWwP5jR17UGQqGN3D11OIKJZfT4fRfOL4McfGGL55XAv?=
 =?us-ascii?Q?UF57SQC5IKKCWawPosu99mT4Ub9Kw+GIAG7heQlQ+OEnSiQrL38sMVTszuTd?=
 =?us-ascii?Q?VFitaZLROTYN0QuJDxOkuLNJBwinVh7no1dYPKM7oLJ2KVUFcRhUlmY8e/eN?=
 =?us-ascii?Q?ySXKPjdvAp66df1Q+tNXTNRs9UCbuuFZTtFiYKvhq2Z5nE0kxxntOddFAJYH?=
 =?us-ascii?Q?xEUUbFYs6nGQDea9MCWEnd7YVJi5LIdbDvoo+7bF9jn0ej0+EDISvXB40xIw?=
 =?us-ascii?Q?A9ucvz6/R6jaR0SM/kivDFKXii2LVld3QFPOpE10H9MrIWvuNSe8JGhDS8LL?=
 =?us-ascii?Q?hVgQhffmBxOGaqh7MAr1rqKdJNLRjUZ2ebPcOteDPx1FoFPLe+dl414PtbJg?=
 =?us-ascii?Q?N9LeY+Hp+rFlK4SY8S+KDG+w7PG+Lbeb8wqg3VNDtGYEVYMxexnBRcw2/7qB?=
 =?us-ascii?Q?ZOyjr06QRCidfKd4mW2nueCv2HZX144D7fj2PcKghD7WKL4J+hRAF9kw1OiS?=
 =?us-ascii?Q?BAb4Oou3E/tjaMFbcOEvCB5PsAvekEK6LPwgi436Arz8dPq1vOtS/llawsLB?=
 =?us-ascii?Q?W0fxRh/Lg91a3zxGJcT7aJ3o/vlLAJI6XTsIap3JSRU1+eTeF1Ap?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBEB77FA9BE5E54FAE477635A572763A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e148d220-6efd-46d6-39dc-08da336c0c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 16:33:58.0071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Gd4zoFpxPY89TPLhpyTLGD4lK3/2DvYPVjGr54D9NZKHhpV0FuxIaTM3GRfcuNqahM/TaP+dKriC7/+kiJKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1148
X-Proofpoint-ORIG-GUID: MnyiY6fEr8mVID10h0lJT_-8P9xhKseB
X-Proofpoint-GUID: MnyiY6fEr8mVID10h0lJT_-8P9xhKseB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On May 11, 2022, at 2:24 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Tue 2022-05-10 17:33:31, Josh Poimboeuf wrote:
>> On Tue, May 10, 2022 at 11:57:04PM +0000, Song Liu wrote:
>>>> If it's a real bug, we should fix it everywhere, not just for Facebook.
>>>> Otherwise CONFIG_PREEMPT and/or non-x86 arches become second-class
>>>> citizens.
>>> 
>>> I think "is it a real bug?" is the top question for me. So maybe we 
>>> should take a step back.
>>> 
>>> The behavior we see is: A busy kernel thread blocks klp transition 
>>> for more than a minute. But the transition eventually succeeded after 
>>> < 10 retries on most systems. The kernel thread is well-behaved, as 
>>> it calls cond_resched() at a reasonable frequency, so this is not a 
>>> deadlock. 
>>> 
>>> If I understand Petr correctly, this behavior is expected, and thus 
>>> is not a bug or issue for the livepatch subsystem. This is different
>>> to our original expectation, but if this is what we agree on, we 
>>> will look into ways to incorporate long wait time for patch 
>>> transition in our automations. 
>> 
>> That's how we've traditionally looked at it, though apparently Red Hat
>> and SUSE have implemented different ideas of what a long wait time is.
>> 
>> In practice, one minute has always been enough for all of kpatch's users
>> -- AFAIK, everybody except SUSE -- up until now.
> 
> I am actually surprised that nobody met the problem yet. There are
> "only" 60 attempts to transition the pending tasks.

Maybe we should consider increase the frequency we try? Say to 10 times
per second? I guess this will solve most of the failures we are seeing
in current case. 

> 
> Well, the problem is mainly with kthreads. User space processes are
> migrated also on the kernel boundary. And the fake signal is likely
> pretty effective here. And it probably is not that common that
> a kthread would occupy a single CPU all the time.
> 
> 
>> Though, these options might be considered workarounds, as it's
>> theoretically possible for a kthread to be CPU-bound indefinitely,
>> beyond any arbitrarily chosen timeout.  But maybe that's not realistic
>> beyond a certain timeout value of X and we don't care?  I dunno.
> 
> I agree that it might happen theoretically. And it would be great
> to be prepared for this. My only concern is the complexity and risk.
> We should know that it is worth it.
> 
> 
>> As I have been trying to say, that won't work for PREEMPT+!ORC, because,
>> when the kthread gets preempted, the stack trace will be attempted from
>> an IRQ and will be reported as unreliable.
> 
> This limits the range of possible solutions quite a lot. But it is
> how it is.
> 
>> Ideally we'd have the ORC unwinder for all arches, that would make this
>> much easier.  But we're not there yet.
> 
> The alternative solution is that the process has to migrate itself
> on some safe location.
> 
> One crazy idea. It still might be possible to find the called
> functions on the stack even when it is not reliable. Then it
> might be possible to add another ftrace handler on
> these found functions. This other ftrace handler might migrate
> the task when it calls this function again.
> 
> It assumes that the task will call the same functions again
> and again. Also it might require that the tasks checks its
> own stack from the ftrace handler. I am not sure if this
> is possible.
> 
> There might be other variants of this approach.

This might be the ultimate solution! As ftrace allows filtering based
on pid (/sys/kernel/tracing/set_ftrace_pid), we can technically trigger
klp_try_switch_task() on every function of the pending tasks. If this 
works, we should finish most of the transition in seconds. And the only
failure there would be threads with being patched function at the very 
sottom of its stack. Am I too optimistic here? 

Thanks,
Song
