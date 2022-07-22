Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506A157E3F9
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 17:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiGVP6t (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 11:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiGVP6t (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 11:58:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3893F316;
        Fri, 22 Jul 2022 08:58:48 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26MBEIik016085;
        Fri, 22 Jul 2022 08:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Vb2m4AUzO/92gzUggwEzu18rB6wLaQBku6G0wt80Kq4=;
 b=nMObu6jm32VXIEEkndR4kInc7CwBeCcPN+9BJqYXN7gqBTDKUIvDG6kHbufS0LEt3HCy
 yCFJV/KJsMqZHwl6ggppaxZozlVc+aeQrY1x1ogAQlISsM71EPWVOqGeJf3Xurm5Ez1x
 UNXcJ0IxxRbKZX5K6UWQHfCQ1lEtRG4PhbA= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hftudhf0c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzcLo59IAoJFVQi1VSQpB9tnUPhDEGqVMdKIXdEgJrS1l/aZrgk8TMfkaUtvpvB5bxDT9ktzBN1c5o/MByFcMLB9Xf4fzjKhnWAo6kzGUlPvEwKGYYcXcqpa4MHS0WlqPPKsCGucXXsOAkvLBqsqmW4uf1b+weEotpbR5GXDsqRKFA5hsvTeuzydJc67QC/99A9funzyIzMEn67lfGa+j0mJR5AewTD6vy9Eff/lYn0gJlDyOIM2ordfj/YMt66i84VyjGIutlYrDSG9snLAQfq1UOlfxLZVNPZXXTjdCF5mtWhlEAstda79MU6k6R41+ol/89w2CCXABXOcTDUVSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vb2m4AUzO/92gzUggwEzu18rB6wLaQBku6G0wt80Kq4=;
 b=KF/aRAeuJUmvJo38/ydI179NIulV2NltAMrHsy5eebnKseLZV2Qf8QVfK6FhmO9d/+Avu/2JgI0hp0mvRWW9ogGa0TO2WjwX+xXdrj7NaIdXYP99bSGCH8B4MwHiA1K1p2sy959xJxUwWekEZfX4KfUrffwdxZLajbUfbrNiojBF6P618q5K4aO6aXqbm52V7rJQf2LZAFuXHHJI+kF6lZLVFLBdfihYdauchM3h5s3r/HkD4N+9We3YNvu/NOn3HuBdViuv740PbIYHYFJ+lGeFXS6WKinIcIowS9qXnaz3q8YSzFDhWHFyUInaWMJxc1UtDb76pvuXStj6H3X+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 15:58:44 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 15:58:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <olsajiri@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 4/4] bpf: Support bpf_trampoline on functions
 with IPMODIFY (e.g. livepatch)
Thread-Topic: [PATCH v5 bpf-next 4/4] bpf: Support bpf_trampoline on functions
 with IPMODIFY (e.g. livepatch)
Thread-Index: AQHYm867cA/kFP0JOE63cHMP70kSD62KAmOAgACN1YA=
Date:   Fri, 22 Jul 2022 15:58:44 +0000
Message-ID: <C3E68D67-CC94-4BF0-90C5-BEF3E7784A21@fb.com>
References: <20220720002126.803253-1-song@kernel.org>
 <20220720002126.803253-5-song@kernel.org> <YtpSOTlpHbKOKTDJ@krava>
In-Reply-To: <YtpSOTlpHbKOKTDJ@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba571d53-5956-41dd-28bc-08da6bfb0e50
x-ms-traffictypediagnostic: MW3PR15MB3883:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3MBYUdKSkcSRxB7OpUMHD3DtBsyR+Nb86C1R5OT+KtQldESAu1+6NNdD2KuvaIeSi9pslfq+CIOxHw2qiB/z1OvbeC5y7t7vJnebyJ6kik7oDX1AVv5lJ2sXNGFbsZzFP8OScDQAr0OtOMXZmQy/uJKYhaEozWEq2xWrxa85RJJa/1UP1BNaPS3nZN4pIxINO6DqCTc7rtMuHR60JoIoh78dYZDXeVQ5/WTLnsAXzY9YBZtbIqEZoAAmJCCYHWwDoQvoju+z/uTF1EKZIcTGybfMF8qV9aU0Ig+gwSFDFCQdjQK39FDpzb2oaLzJdOi7ykBX48IHnzSSQbDdLqjhbF9O+J0OIF1R3OP/T/xb5amPnt1KGxKDDXYa/jXzAZJbEph5DgiDA9psKBMyog9g0+sYKU7aPNNOrJ0X0+myGMyQOALg9D9tsmM5xCaKvYYilMo2qwbwFNgAGLrrfQllWyR5/2zFufqxm2sbTV9DabhMr3Fu80McTCBu+cyXbXp2C3P6vjawZNsv9U5yRT9RA8IXxv3J1jXjEMUMT1hTz+Rhi/HlFi/LFYLQwmYgtP1/IZsVJ8fPhBcpLvpGArW/MipE9586NpYx6dJtI5isu21esDVGwTQeCP5V9SpYkgUBw3BkWIjxylqYQvZaXMCqRgp0dgwe/KEHjca2Dm8z3zZUig/kfLBpifFY4YoJB48X6niUscTwUiXQWOQX8b78C2aBhfGfEFlnnGatx2PUIXdKujye18fYBEXVNzqkTo1qqkDa55hEk1+tjKzDqbfE/EgpQz2mNNstiOjyZb9ncb+1HhQW2fymRKMwFMinqM0ZocM5gvIarUuLxT+SWnovBXkGoXvbP7794M2JIi2XA06q2nxQKokD9cIwaQOHRuGd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(5660300002)(54906003)(6916009)(122000001)(966005)(71200400001)(66476007)(91956017)(64756008)(66446008)(76116006)(66946007)(4326008)(66556008)(478600001)(316002)(8936002)(6486002)(36756003)(186003)(6506007)(2616005)(8676002)(2906002)(53546011)(33656002)(6512007)(38070700005)(83380400001)(86362001)(38100700002)(41300700001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?brlqFtHjtDwQ6K4mDnk1aXBbP5CO83mWkX01CALQnJfkTPQnVlLcF03l+YYF?=
 =?us-ascii?Q?kabRLP5quwGZATeP67gsp/jV/MggSr+D9w5G4q0useUanL+IBBJSHtCZdH+f?=
 =?us-ascii?Q?a4hx0bFckc/ua5knJyAY3H+3F7dLqTLVv3ygHwruNQ0NI2olc0qooxFW/YxU?=
 =?us-ascii?Q?/QCBgPmXrbWRYxiUxQWa3DuQSxp9JebAoQyF+dIw/5ktnnFqq2+NLOUmuudz?=
 =?us-ascii?Q?HGQgnWAAJCFfY3itlEkKzc7nHCiPf8VnoaptEALgxxkm0TskFC7/D2m4T4y6?=
 =?us-ascii?Q?PMpNxFf9d0DdIClrRWb8MqJzlUZH6UwJH1HxWqd6KKWSAVTjWCKKqAFE8ofq?=
 =?us-ascii?Q?3qGPksQoJK4uZSWzyDV26MeadxBvslEFrNaVcb3JVdvOn74J9xCi11Z+DVz2?=
 =?us-ascii?Q?fJtm29Gewk5pP0wM1/wyxiOVFmYMiVm1/g7nCLbl+kw7rVTMLpVdQyBb4fv1?=
 =?us-ascii?Q?tDEBCWTZneeQu5uUqs0ksmEH8wF4T4zhMPwUaEBGExd/BbuPYh4zBeUhziIY?=
 =?us-ascii?Q?B0wYVo9fAZMUI22UaiRgzM/GB2Kzt18vT1wG++DD+S2Q2TI/s7lnA3mVWgSz?=
 =?us-ascii?Q?ykwHL16iAQj4dkpF58tS4qgJPOk4FDDJu8oyC9bkjspepozIN4o+h4mbTGSs?=
 =?us-ascii?Q?EzCnbh/oTfCb8oJYSy8wpfj0W7f6BM2kxz2sO/tR553dRwFrYJdMn5b55lHn?=
 =?us-ascii?Q?3LUMitWV2WUpfKIeyQvb15XIorzdA+TiVV79xtMgi3j/Si4kvKFF2edKYGay?=
 =?us-ascii?Q?ko569wLgwefBSvW/0dTPhWx99aE79gsqSochymRBChA3Pplbxr3l1fAhP8BI?=
 =?us-ascii?Q?lKiu/hxoT40gvu+Cuw0BMbNVWIJ7BY2btmQoGbUMrEZCODCnSnXZT9DxWUpn?=
 =?us-ascii?Q?uO8/OR+IZcsKysnZaypZXPNMcToC/jWeFh/DXOC7i2+CmTwSzwWx6Vtun0HO?=
 =?us-ascii?Q?aPMT65UWvsMSkIlstrOSls0KKRRWufXhrXkX/1h1TPs29U04e6bgTPK+6QU/?=
 =?us-ascii?Q?xnmMULJmOefcAp3LLnywN1xpIxkhRMGSFOzO2afS+xs66gU3vY6GRScVPQk+?=
 =?us-ascii?Q?a47Q9e8lOifedFpTIj+3y+d/jRUL3rgnUBuOvwzMQSYORHGSErzTovIXSZRp?=
 =?us-ascii?Q?/GNvwOODnV/nc78qBvuaayjEx8n9ahOlr0qm97jRF4dIYT7bXsWTDqPQKigG?=
 =?us-ascii?Q?ErG7QLLd4d6vxJo1P5O2ih9Zzqh4ZdWAbxj9zAL2EwSW7qegZ3/IdLmdFyqU?=
 =?us-ascii?Q?ZN9D7FoyX91nWCsefh1lFvS4K7zvPN6rN6b1iglrJQ9+yLeDfh0ZBHCQYJMs?=
 =?us-ascii?Q?8UpxGrpIk06SjyH7fsb+K+1s1fS+F5xNX3QZjU5/TTYeaWPRM6zxAMW8+4VE?=
 =?us-ascii?Q?kXzbnoYTCx2vMZT4cxG2gtw5tFYxOXVhbsZ1zp7bQWn7vYaUA1eYo5XnGajI?=
 =?us-ascii?Q?orqT7Hpn1fP5WFc7w/FJZwgwwmYHSaJqErbko6YbQxX7NB1qYQAt8pve9Zda?=
 =?us-ascii?Q?pkOjeYa+Fl/nKfQlNvPvB4TJNgpvNkIFElqEtDNXg4taf0ZzmR3v68puOD2R?=
 =?us-ascii?Q?HcG1/ACi54kmWYMghjjcYqJf3Mlrz7XUWAboTl+eMLOCX5KRZZdicQ1Ug+r/?=
 =?us-ascii?Q?nn9yxR5oZfo1Hl9fQG5dr98=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5BB07BDFF0AE2E4F90B1C93EEEF9112E@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba571d53-5956-41dd-28bc-08da6bfb0e50
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 15:58:44.6819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zfu92GCRROM1K8QaIfMsQTAl+kpH0N+R34aLAwPMYyYI0X2LkDGaq5mFXR5HN2+IA8nzfnoI+LIkwFmeiinZVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3883
X-Proofpoint-ORIG-GUID: tsM2815R4g6D4ITgs-NmXuOngnTC0eQ0
X-Proofpoint-GUID: tsM2815R4g6D4ITgs-NmXuOngnTC0eQ0
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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



> On Jul 22, 2022, at 12:31 AM, Jiri Olsa <olsajiri@gmail.com> wrote:
> 
> On Tue, Jul 19, 2022 at 05:21:26PM -0700, Song Liu wrote:
> 
> SNIP
> 
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
>> @@ -89,6 +165,16 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>> 	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
>> 	if (!tr)
>> 		goto out;
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +	tr->fops = kzalloc(sizeof(struct ftrace_ops), GFP_KERNEL);
>> +	if (!tr->fops) {
>> +		kfree(tr);
>> +		tr = NULL;
>> +		goto out;
>> +	}
> 
> would it be easier to put ftrace_ops directly to bpf_trampoline,
> not just pointer.. it's allocated and freed at the same point
> 
> I recall there were some include issues when I tried that long
> time ago [1], but could make the change bit simpler
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git/commit/?h=bpf/batch&id=52a1d4acdf55df41e99ca2cea51865e6821036ce

I was not aware the CC_USING_FENTRY issue. However, I think we
would like to avoid including ftrace.h in bpf.h, which will 
slow down the build. 

Thanks,
Song


