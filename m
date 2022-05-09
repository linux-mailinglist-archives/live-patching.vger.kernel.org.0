Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230DB520275
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbiEIQcd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 12:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiEIQcc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 12:32:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98572438ED;
        Mon,  9 May 2022 09:28:36 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249EkFnO001627;
        Mon, 9 May 2022 09:28:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=0uVIhV3JDHjr/UtbdMrTcINgP0CXxC7qMV/QEGEO1tM=;
 b=d4dhsXnVodF2sGp57NV+/qMvd1+6t5sQXlPLLPkEO0DEtjIX1u2xtIfwb4aYPWGazkqL
 NBL1gywfYlLcs2A+hxI0uAudxGRqTK9mPurQ5SpJu3xdJPjn/QwF4hLWbsRryHNi3QLA
 zKdIe0o1/eT541K5CxPFPX4pKPtVdY4GjcE= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpkshkr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 09:28:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAKsLnGsz61IQtmLYby1Kp7Eo14JtE+ltHg7usL2cX9QMcMdiuaP4IV1j8MKWG7qOYFjhqgwne8IgEbBroFaQ3Ey3U9oiLNiREfBiQ+04vrU+PHFlFE4V/n0jyMQ+hwLwOq52jK2neZIL4uP+HjhWLbLqeAgbaXrhHG3Ao/J12ArNZMrt8apjJT8zEON8Z+9WarRzsfL+zP6yHBJOv3dEsy6iu2WgASLpMhwKJogYIFjw2Js0lgxD+82MZk4KVIJZWDsValdWbLpksyS5Y30PI7z3IWx81UJMbWRb35SHfFKDtTmN7SCt+v+E4RPH21UTxa52BCPs0s9uPMW9pLvlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uVIhV3JDHjr/UtbdMrTcINgP0CXxC7qMV/QEGEO1tM=;
 b=hIoGzEjpm6vdeCrPnhtfbcDippgN1EIljLuaYnk9/I4jciYEE5XZ5X86sghCwX05xU+LzwNsErWzadjygwRigXoF54SKVZcOuBa4piRTn2IUP/V7ar2+o0GV82fDYduVE1emRpqIf5GF4RjB/66DHiszdFutUSAX5A625lCuAIXxV6olvBYymQLz2Jz2PZImaHexAgfnO2Q7h+7toAiOiP4eeOifiPziZ/HC1tLnH+6a87NzkGa5QpWX7JQesUVrOZ0AVl5grZvzyHwv3lt/MaWG2TEaTahsRy4bNgAJmWIdg4Los0sXSUOwRqfoAj1pHYiL6jDW1kxuq6KZlQZ0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2764.namprd15.prod.outlook.com (2603:10b6:5:1ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 16:28:33 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 16:28:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Rik van Riel <riel@surriel.com>, Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Thread-Topic: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Thread-Index: AQHYY7zTSXNMQhssp0imSrtNeUcDwa0WvCqA
Date:   Mon, 9 May 2022 16:28:33 +0000
Message-ID: <DA323AE1-CEF1-4EB0-8C86-4F583C63F0B7@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509115227.6075105e@imladris.surriel.com>
In-Reply-To: <20220509115227.6075105e@imladris.surriel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08bfa2f1-4f95-45e9-481d-08da31d8f5b4
x-ms-traffictypediagnostic: DM6PR15MB2764:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2764A2E8872C7EEEFFCD9933B3C69@DM6PR15MB2764.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WLGv1p3sNFqyhELe8Od0C9vd3RTffx9PFHVY/EX2GQXRnsUNEAUJUzk68T77BqxVZUJ3PfzXyO+1i4QyQ3Nqei2zCd2vI3tYDXHxAkR36qP3nisG+pnBv6HkohpckklvwPvhV6q4IW5qJAwgGPMAc3LadnfvcG9ay2Y3EmHDl4VoNo1d552OHTcP6NH0QZoCMu8Gz97ccB5BVSnbByK0ZoST2r6kDvBfDo070fKOoYzVRh9T5LTELNkK757UaWpSrXiEpRWHL64jUqOYLYkfhDuX1wzNyZtF/aYBXWk05J6D6HlaU/d+nfHnFKA+G8A+wshaCFiiBwjBf6EzpIfY8YX/rvVODlHbScTNDK8M+mM/Rueh4qqOqmNjr3nb6rSZNhFhi2sCQ+3AvkJOldtQ4guej/ysqrL7m+TWxZ+VjTCL9mTjEpht0a1ROtZCytxb3zJ3cB0vypKVG3dW/JcYbM2+AKm0jGxTOxCj1P+f37fFshNXKpl2cnBN9qr8xRntfStn2QLQ9jFUILFPqCn+/P+WNQMOH5+pVuqlKIG5JSCCNKMhnrOSi/Cd0Yn82tiy+i0aND8ouOsC6kjqcVaRvH6dClmLKgobblXDXFKwybSMhL/IAnEJqQrh9eP7thrElXqxhyRVkw7zyZGGdUTJ+tx33OrWLrnt8eHBVcZjlkvjRHfyy1jyKX0T23SNi6SC3sD7ChbvlrZJbrRqpas87x9ov6ai+ifhC3IPvOIG6/P2pqGHTp97yMicfPaYB65Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(36756003)(2906002)(8936002)(122000001)(38070700005)(38100700002)(5660300002)(186003)(4326008)(83380400001)(33656002)(508600001)(66556008)(66446008)(66946007)(66476007)(76116006)(91956017)(64756008)(2616005)(8676002)(54906003)(316002)(6506007)(53546011)(110136005)(6512007)(6486002)(86362001)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RvP+BS1nL4++i11WOB7US+LE6mQv9KcXVc0TnVYs+7LNCQpQUQ0RZYLw+JzA?=
 =?us-ascii?Q?2jBDO5Bvt++j1TvwYlB7q6ZUB+VSOSMGh9ewTWzQDZwiJ9qn5L68wD0exUJ3?=
 =?us-ascii?Q?aY2o/W9YIYONVAsAGDZQVaqK222SarknRmEK5l4LuymTA+xDYgNjQA6MJRmt?=
 =?us-ascii?Q?NMKrMnFiru26F1DLiBoGZ6O5HeYObsPRGhAYoqd6PmnsNRr/+xCH1S8ydlld?=
 =?us-ascii?Q?4RChjW6HZxBYq3IgOKWPSWa3AcFMSrbbErJ4e83TxaoO21nHPwfUugR5SCna?=
 =?us-ascii?Q?DNv1KzaMC/aBe48V1gzOO8YbLCj8S5+HK5g4U9fEJl1opO5sFiKuO4Url1t5?=
 =?us-ascii?Q?EshjHZROcU0des78/uI/voNbik+re4irI1tgSve0LYisf8PgiE9hqz1m4psk?=
 =?us-ascii?Q?lBSU/q6LjKNthvETsvZOHaqjgX53IbmZh/1fkH53emcmqpB/jn/96/nfA1CZ?=
 =?us-ascii?Q?Z1zFAtZWCOHqYrjHqKMM7qIi4NXFR9wOIx60HIVRHEq1EzUtFsSzjBsY16bT?=
 =?us-ascii?Q?Ppu2XEiQFqHLc5AzbNzLlNwAG6sN+kywn7ou/ZYfmAAWyERvhd82QJWJvYYk?=
 =?us-ascii?Q?KWWjOQmcwz/1rYoNa8CBQ6KWst6msZeKeDw7f3eZkmEPPQYqG3hwxd6t9jKA?=
 =?us-ascii?Q?foqdtYUJ3nRPlvSQtYm/zkhrBj1wzchsURZKQOSKa3k5mrmvaXS3eYy0ikfY?=
 =?us-ascii?Q?tjNdlwPgM7quoG23G7CrOB8C81mNeSUr0oNXy21NXjyqvT1VWbq34BH1nel5?=
 =?us-ascii?Q?65tNmnhqdVavUW937vB1JdzLFbEo3n6yiJG3g63RJTqZJW2yVUnQsR/+bkMu?=
 =?us-ascii?Q?i88yum7LOl5H6ZU+XWUdO8MX4xVgyGl6ESuHJXTcr9mLKKM3nr2339i6LlOJ?=
 =?us-ascii?Q?mLGLOSGR8xzlNxhvdpOFH22CeHQ2fhbwVISdrIRX4L59rBFQB56gD0ghf+Qs?=
 =?us-ascii?Q?FYaDe89NbPJCu6hcgUOV+Hf8WJdrunulf+yWwFcjDt7o4LA3myYJeeUIHKRf?=
 =?us-ascii?Q?qblhhXP02WT0IAsZmbY10RBXLwQuHigaRX7pRAtOL4ZJQkocu9EyG13oWnzt?=
 =?us-ascii?Q?l6VwA4jTEzF9cCXPTvpNj+jo1MP2j1vzID14pgbJBRMPc4RrrAK/CU/MCzCD?=
 =?us-ascii?Q?iVIjLuBqWbd30vWaCOJkYSDZtPL/Ci59ivZk3KF26JWA+18G3U9DnQJHqM1q?=
 =?us-ascii?Q?G73O7FoRNu/w+pRLwHf3UqvtMG1UDDtX9JeL3VcQCDXUUT4lH249VAg1HwYQ?=
 =?us-ascii?Q?WuQ0zKW5ExsZH83/QXZ2y71xg4mFRJj6mfRWkW9EfajhbJsgQQLVmgW5eJh0?=
 =?us-ascii?Q?zqly2nw6Xf05+Ht3enxGlcccQoAgjnpX0OBz40zFEf0CRvRkOkFHNP2+Lkie?=
 =?us-ascii?Q?H5brEf7NdS3od6V/Vb+LK9MOvrCI5ofNxqtV/XRvW/uzvgYZ5jEuwZWgFhiH?=
 =?us-ascii?Q?cqyJK1YMFlt7Cm/3Q5iKjfiiUek7t1EuZPQwBwYkkkcefJwZb0k4ztEII64R?=
 =?us-ascii?Q?nOHOSN+ZYeS31kHSZUC8PQ2eCttGdAhP/pRCe8NEl6/fa7Aq4D8dP5S5mJmT?=
 =?us-ascii?Q?czwF2gClCq4Zyw105k3KSzUQBwf2+g7caW5DlYfQc0Dx0g7e871O4gpKUCme?=
 =?us-ascii?Q?EBBF2K05QTOWLSbdXO4kjSqex1RtrggKzQ0btopt5BVF9i/sJF4QFqnqCXX3?=
 =?us-ascii?Q?mFT0zcF5qqCLi+HG+/vU1uWDIf69agTlJxlOMX7tYdsbtTToOFfCTP6+UnJs?=
 =?us-ascii?Q?9SnNajJpuc8G32qwER/RJ8zv3s7tvllCguXyighzbV3tddTv3Gy6?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC05D21A5207A24985D1FB9D2D67A053@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bfa2f1-4f95-45e9-481d-08da31d8f5b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 16:28:33.0806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJux6rQCe7Jx2OUYv61K6DgZCch7FUw5rQ6Na5lecgjA/yIPUcfkaP2hiflKYmpu2LLCRA8Ku+Eubt28zT0enQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2764
X-Proofpoint-GUID: x4v0Ib7lhg8fc462-nDMdDOfjjOtZEfc
X-Proofpoint-ORIG-GUID: x4v0Ib7lhg8fc462-nDMdDOfjjOtZEfc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On May 9, 2022, at 8:52 AM, Rik van Riel <riel@surriel.com> wrote:
> 
> After talking with Peter, this seems like it might be a potential approach
> to fix the issue for kernels both with PREEMPT enabled and disabled.
> 
> If this looks like a reasonable approach to people, we can run experiments
> with this patch on a few thousand systems, and compare it with the kernel
> live patch transition latencies (and number of failures) on a kernel without
> that patch.
> 
> Does this look like an approach that could work?

Hi Petr, 

IIUC, this is similar to you proposal. Could you please share your thoughts
on this? 

Thanks,
Song


> 
> ---8<---
> sched,livepatch: call stop_one_cpu in klp_check_and_switch_task
> 
> If a running task fails to transition to the new kernel live patch after the
> first attempt, use the stopper thread to preempt it during subsequent attempts
> at switching to the new kernel live patch.
> 
> <INSERT EXPERIMENTAL RESULTS HERE>
> 
> Signed-off-by: Rik van Riel <riel@surriel.com>
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5d03a2ad1066..26e9e5f09822 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -9,6 +9,7 @@
> 
> #include <linux/cpu.h>
> #include <linux/stacktrace.h>
> +#include <linux/stop_machine.h>
> #include "core.h"
> #include "patch.h"
> #include "transition.h"
> @@ -281,6 +282,11 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
> 	return 0;
> }
> 
> +static int kpatch_dummy_fn(void *dummy)
> +{
> +	return 0;
> +}
> +
> /*
>  * Try to safely switch a task to the target patch state.  If it's currently
>  * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
> @@ -315,6 +321,9 @@ static bool klp_try_switch_task(struct task_struct *task)
> 	case -EBUSY:	/* klp_check_and_switch_task() */
> 		pr_debug("%s: %s:%d is running\n",
> 			 __func__, task->comm, task->pid);
> +		/* Preempt the task from the second KLP switch attempt. */
> +		if (klp_signals_cnt)
> +			stop_one_cpu(task_cpu(task), kpatch_dummy_fn, NULL);
> 		break;
> 	case -EINVAL:	/* klp_check_and_switch_task() */
> 		pr_debug("%s: %s:%d has an unreliable stack\n",
> 

