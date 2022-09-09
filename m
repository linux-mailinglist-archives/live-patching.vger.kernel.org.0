Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB615B3A61
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiIIOH4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 10:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiIIOHY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 10:07:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46687EE98E;
        Fri,  9 Sep 2022 07:05:31 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2895WqtD024173;
        Fri, 9 Sep 2022 07:05:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=mv97ZkEXj6IbwdhIALlrBjL4xyJ/+8J8Fa1tjanYwsg=;
 b=MgN3pxoD2fApR8wFcBfL52tk+XxxaIXzkGXizIehbxDtdXTJbWfFdDt+V7SmDDpRZ9cc
 O5LhkTakpb8Tswa6AV5UOC+Hc4vpCbCA6FrwQ+cI8Rfq2XGb67t2R7MNw+9BaOt1Nkge
 LxQBjA2n5h3zALklKgrgqfG4Cu+iif9hjrw= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jfu2wbc17-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 07:05:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1lh4pQyN647riOfiADgbTQXnJN75zyFcuzYQvKHOMOIg1bMUHvw4GXbS/HpHgNrn7ZWY6GCfYRM4SuqBy6oegcQ5vGHf9KYIR+dMDh7Poase4U+myyZ+jBjZIt2EoS7hFosGQ7VDImF8DeUTCpLifyezv7KoJjPygh01YNqx8dKlh7DrOZ3QwZof1p8JvtD6UUOQgTsUHYyyl06T4s1DyU0CBIq2cElzJ1ijBY71PtIFs4Mpb7TiBvYlOljNPfShYqvgPdFhf74qozGh2jxwJhfpIHodIDB7QJYtgUXotGKhRh60fMuzx/LSaGHXH1l5eyjjZW4EeBa3zNMhtNkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mv97ZkEXj6IbwdhIALlrBjL4xyJ/+8J8Fa1tjanYwsg=;
 b=OBAicUVDZ22iP5CT/PU7f5tqLimYSi1PVKJZBMblp+LToIDhLaowpS0Zhamp3IN5p1q0w45KSgeWhzQOUmC74/pwiub9q90qzZA/hM9W3sMKkSCJWYWFkC03lWdGHfPuA3od6S7rpPQZeasbZ1RtMp6vuHzsvK7Os1tQjKzp3LcJTyHggQvUQOIfbgEcHLsZp31c213rkLUr7a/T6O5FwzSBU8BA00NiMo9djoJ+jqCbJ7VaB3iu8R/3dBd42aAQfWFKDHPgGSeorRSLiCDceiORmBdl3bs1Td2tmNNTl5NAu89zZbBkqVDJSZhYHMe6+tiqgiQymgpHtxCMhZGYPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1852.namprd15.prod.outlook.com (2603:10b6:4:4f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 14:05:27 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::2374:1d5c:fd6e:a28c]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::2374:1d5c:fd6e:a28c%9]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 14:05:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
CC:     bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 2/4] ftrace: Allow IPMODIFY and DIRECT ops on
 the same function
Thread-Topic: [PATCH v5 bpf-next 2/4] ftrace: Allow IPMODIFY and DIRECT ops on
 the same function
Thread-Index: AQHYm866tO7bjERJHkCJyhnS5ItUtq3XT0KAgAAjiQA=
Date:   Fri, 9 Sep 2022 14:05:27 +0000
Message-ID: <B59F0FD0-FA3E-4A8B-B588-8F9AA8AC602A@fb.com>
References: <20220720002126.803253-1-song@kernel.org>
 <20220720002126.803253-3-song@kernel.org>
 <1662724350.8os86rhyxk.naveen@linux.ibm.com>
In-Reply-To: <1662724350.8os86rhyxk.naveen@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM5PR15MB1852:EE_
x-ms-office365-filtering-correlation-id: f544f86d-38bc-418f-68a4-08da926c590a
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KwxqsjTJ6tkbe3aEQMDXNkuixMlmotlmn46EEVjTJ4Vj5ziU2Qj5PlHOfFGpzoNZcTeUEuso4Wacwnd+ef6XMrUi+RvyXPE/R2KuNm1j7ILG4a+bnjE6cXIRFXN+lOVjVtDqHFeR4qOYzSHMvQseSc8HytQ8gv6lV8p8cMn0U3b3KnWwmpVtc29+T4DGGhxMt/7+Ye1PyGULy39cgNvCSLNDUahIflJGu0KosddquCBi71cBVd1qP6k4Je35sSlhRIwWNjdjBZJiM7Rsng7EJL0UwhY9jbuYF24wJFXddZxziFNusJHu6STWwKFXsc8zPuouBn57gPmydn1YEQjP1i44PzlGMI6vlwZTDBIc/dVxnSC7o4811fzfmexkfJGEZVqseUWYOQyss3KoXGujUBPbNuTx/Fe8iTKx9jpVoIMPHerc9dgiWYMe4KOfBjzC2gbS4nc0zOOeFeRSft6GOiIGtIlj38qPinZsXU2NV/ODogLSdlr7SieQny4tdqrsDSwbfGEEWsacHR9uM5PU6qTln3m1YAAoH2Dx+53CS3xdX8wLLrZzHo2Si3bqUZqvSbsAyoroQxLoToPtzCEGRCuTNZTyf6jx/Kc2+CJbIHHiCBVaTe38aRUKgeCOVXZDFsXJt6ZZ0xY6vtrcgJXgxfpPVeHCsElXtZQkZj/f5IwI9TIJXabSUS1uEcEcGQj7lMIZK2p8gRzWAQs7kRWQRV+NmvODfb/jossYh4F8yaW//me13rgiVrJXSDaoUp/pwbewvmB/bORYPdgfNuSCNAcHuFsC+nDpsbBCpvChtfQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(2616005)(6506007)(41300700001)(53546011)(122000001)(8936002)(38100700002)(5660300002)(6512007)(36756003)(83380400001)(33656002)(2906002)(186003)(71200400001)(86362001)(6486002)(66946007)(66446008)(66556008)(64756008)(478600001)(66476007)(76116006)(6916009)(316002)(91956017)(4326008)(8676002)(54906003)(38070700005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aj5LNa/x2CXGYntE6/8/yyaZDpusr4cov05NTg0kqB8xBtXvF55k/rXD/HqN?=
 =?us-ascii?Q?R++QgUYcdfiw9oMIo4dLQdQ0/q6nzYqQBHyhgddqiphYPvShxezxMY6a7Po9?=
 =?us-ascii?Q?FsmYY9HaePJcsXPYsAn6K/hi4jMuW7aHg8qetAoD0oDSkbRJ+WWnXkoz3/+/?=
 =?us-ascii?Q?W6e6QveRFng1WTp6LlmQ5hPreDjVCkUj5n6pn9PLoXjBL8RGCFdhuVjaNyTO?=
 =?us-ascii?Q?knkoOxZmoCqH2WWxbddOJvxV7L2LKHbp35QyMC9e+03nlTssNahNVxz1bhOB?=
 =?us-ascii?Q?f9swcvDC++ZHnjKeSLdo1DRwtoTQZtZaEcc/fjGAdIMq6b7KgVrImz8Xul+d?=
 =?us-ascii?Q?HtlueEC8eb6/OY4dTV722vE6q0x+QCjITpUkrHzuoEPwdD0GwD/PVyXli9/r?=
 =?us-ascii?Q?71XtwWHHPWD6No8qKFxSZciB33eclrpGOVo8c/hzK1A6cPXeEk/A9OvYhk0m?=
 =?us-ascii?Q?YJLLZSQ3kpw2FiRSZIsi2eeb/dWh1xCxmpHzDBnQMwb+tgV6zB0uMMYsS/El?=
 =?us-ascii?Q?TbMjQljmPwAArkg3GPo2zADQ5f0fhQHZpnHs/jPTAaJBDb3XiUwhHHl0gQz/?=
 =?us-ascii?Q?6CSeFlz7BsGWZhhxWWnCK3yGLvvtWEB755hgvQRshW81tTMVnLAXtDTwlo73?=
 =?us-ascii?Q?L2kSlu2PM8YKY19+lpMeiBsrKLfnj/ZVv6x6vNl6MwkmBDgDfgrBnksLh9Jf?=
 =?us-ascii?Q?HC213xQXQlqI5Bf756iaVTGl8As4EmVJr+qvWmqk+r2vn1SetRmJbNCgcX0g?=
 =?us-ascii?Q?e5S/Mcol/TRmXwUSXDTGfyEh/crr+pBb0Lql8Ic27POHy3o10BvUU26Xs/dI?=
 =?us-ascii?Q?PDjwRq2KRjzCR4Xyu5e+ynq3O7QSNlUx5TED77/7m3+0F/3F2Gn4HT5oos77?=
 =?us-ascii?Q?S70ZCA0aFCyYRCGUivsE0BjRhuJKlaCdzdtpX521dK9CeHGbThLkW5G6P2ra?=
 =?us-ascii?Q?x9F3la8qwiUq+3CPZ5F2waf4pxaHl3gSXWZ7hgVHSGUbPDzN8Scjt0K/4SVH?=
 =?us-ascii?Q?apDL45Iq15HGSc9zDffrqKj1/xYvIwSADxp9objxl286DY0y9lVV45o7OKvS?=
 =?us-ascii?Q?qzKeMWGHmqVWzWcITDdR1TS19IkMgvDIeDMI3n2Ugs6pCmF7wEQCGWOG+wBy?=
 =?us-ascii?Q?xn9TvxwSidyZtMVNt3rIzOroxz9zWIcje2BKU5iyEcf3MP3JcZSyVaH9DzKK?=
 =?us-ascii?Q?ZmOzBe9oCBIU0xvrmPU13jStxLYGDR2brFSRZ6i0hLfMgiVpG3EqNx+4D1PL?=
 =?us-ascii?Q?TByQPSUG9ezHfRX1uqIhsjjSl/MGj8Yltlyqaf7OTiZEzAsZwjotDtmxzkeJ?=
 =?us-ascii?Q?ayQ3QF43QHvy6/98iTZfi/ioLFwHyTFXp6jzODQtFovTtMIRoHZP+KU7rfGH?=
 =?us-ascii?Q?GlFBG/9hM0qEe4Wx5JtRU3XR9Vl+TlOXwT3cbhJGc6dMuyDk5hCb9Wf8x5IG?=
 =?us-ascii?Q?n+KSYReLwHLyMOip1PLub/gqsPHtValVx/RJ50LFK4UPU7uhGv3eYfi3Ig3w?=
 =?us-ascii?Q?RxrQYO3VKLefJyuWIvEFgf6yB9yjxYenJDPaTyUtOD3YqkElwyfkeFNwzyGT?=
 =?us-ascii?Q?OdESlMtRxfXxbjRdhWSIXNgCMqi4XkksCr2H4qbrrTzH1E+CZVpSUqCJQHnB?=
 =?us-ascii?Q?mziKGWXQtQLgWkuixBU73m4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <496508A65D46D1429280C192B4304661@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f544f86d-38bc-418f-68a4-08da926c590a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 14:05:27.3699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCDA+rPlGTGjiL3k/Vw8nOGrCa8Nsv5zdgEkUjVw5DjGF3glYvrV3D+1NMeFqGaCOSCo3jznmy3713/kwg4fOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1852
X-Proofpoint-ORIG-GUID: 0AWqwpQ3-RpR-fe_rXCanv-c45vc93-D
X-Proofpoint-GUID: 0AWqwpQ3-RpR-fe_rXCanv-c45vc93-D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Sep 9, 2022, at 4:58 AM, Naveen N. Rao <naveen.n.rao@linux.ibm.com> wrote:
> 
> Song Liu wrote:

[...]

>> +
>> /**
>>  * register_ftrace_function - register a function for profiling
>>  * @ops:	ops structure that holds the function for profiling.
>> @@ -8018,14 +8206,15 @@ int register_ftrace_function(struct ftrace_ops *ops)
>> {
>> 	int ret;
>> -	ftrace_ops_init(ops);
>> -
>> -	mutex_lock(&ftrace_lock);
>> -
>> -	ret = ftrace_startup(ops, 0);
>> +	lock_direct_mutex();
> 
> Trying to enable ftrace direct on powerpc, this is resulting in a hung task when testing samples/ftrace/ftrace-direct-modify.c
> 
> Essentially, the sample calls modify_ftrace_direct(), which grabs direct_mutex before calling ftrace_modify_direct_caller()->register_ftrace_function().
> 

Thanks for the report. Would the following change fix the issue?

Song

diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
index bc921a3f7ea8..2f1e6cfa834e 100644
--- i/kernel/trace/ftrace.c
+++ w/kernel/trace/ftrace.c
@@ -5496,7 +5496,7 @@ int __weak ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
        if (ret)
                goto out_lock;

-       ret = register_ftrace_function(&stub_ops);
+       ret = register_ftrace_function_nolock(&stub_ops);
        if (ret) {
                ftrace_set_filter_ip(&stub_ops, ip, 1, 0);
                goto out_lock;

> 
> - Naveen
> 
> 
>> +	ret = prepare_direct_functions_for_ipmodify(ops);
>> +	if (ret < 0)
>> +		goto out_unlock;
>> -	mutex_unlock(&ftrace_lock);
>> +	ret = register_ftrace_function_nolock(ops);
>> +out_unlock:
>> +	unlock_direct_mutex();
>> 	return ret;
>> }
>> EXPORT_SYMBOL_GPL(register_ftrace_function);
>> @@ -8044,6 +8233,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
>> 	ret = ftrace_shutdown(ops, 0);
>> 	mutex_unlock(&ftrace_lock);
>> +	cleanup_direct_functions_after_ipmodify(ops);
>> 	return ret;
>> }
>> EXPORT_SYMBOL_GPL(unregister_ftrace_function);
>> -- 
>> 2.30.2

