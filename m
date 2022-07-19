Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8EA57AA67
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 01:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiGSXYk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 19:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiGSXYj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 19:24:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FDA481F1;
        Tue, 19 Jul 2022 16:24:38 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JI4wav009632;
        Tue, 19 Jul 2022 16:24:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=8lkSXAh40yPglrg3rwtLvve8/o78l+G2sJdJeu+ZvK8=;
 b=X3b5NRFCimO9qLZd796dqPnrTJsl1yERgARfy1UbjsnJyFNynaU5Hk6M3/n6NItY6utV
 3tPKog36EN9LtG7Prw1fWn3S4OeOJFOG9plEm5j202g0c8phUyW/fgCCz4NZFdELWaom
 31UCOuq4cc3ef4vSzoqiQfFVin1ODhHerFc= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdv1k4jqw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 16:24:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbsGu+ywDHTOrrGDHBdCG8P4j5+kQMaw3pSu7hIjsoxEcXl3UIUUKkqbMEuR/iqZ5s7X6thZbbOspe1juje90YoCyLaUY9CFitKcD19xFjJot3Xo7hPN88chxdp5loruU61xxHA5YIPnIKYWQNtP5JwTzWbo2Zj79eVlkBma5iSyHty7BnhQwQOrg7salq5FhSNHyPX9oDRt38U3g1MLrWxFqlGqZej/wFj50AItdefPlOdUEeQs1ko3AnPkl+HnsAZHQ+pR4qFgqBXNJyUS/gb1rxDioH8XD650jzt+RGUmSTE9qdj1Twl0jK3GKQNNkwgZsBvEn/rOfeGRFFJjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lkSXAh40yPglrg3rwtLvve8/o78l+G2sJdJeu+ZvK8=;
 b=h1hzYGxR8Qrrr3PJFdK4JoG0WDTdfoZ/PCEakZ6hYTFAkwNWU0A7sYRr9QHxYDuetZNSKN6kDY2Le4EgC5S0W2WTjoukBMPiERzOvhTG07pHjdTPSx//10w5nooxMar8THltLeLRN1S80gA7E2BTlU3sz+Lge+dwQzFfQ2lBviFlAgqQMTNf188AAjgGOVXxTN1xqp9ZGnLHiawn2szCl1tdc5wym/XnUDbOWvFjLu9ox3QjpquB2iIddlU4Ce36JHSMIpzLc5En3yvEdKKGw0ZIVQbirEXoPx/Yxk/2vw3PLJbssKDfVCrDL1aHxE/+xaVuE+NNaO+6QTTpNnamXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB3520.namprd15.prod.outlook.com (2603:10b6:208:a6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Tue, 19 Jul
 2022 23:24:35 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:24:35 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Topic: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Index: AQHYmmrwWVTrDYAzL0G5ckglE1ecDq2GBfkAgABSmIA=
Date:   Tue, 19 Jul 2022 23:24:35 +0000
Message-ID: <D9D41674-8EFF-4A30-97C5-F2C1B31C1F22@fb.com>
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
x-ms-office365-filtering-correlation-id: e9e076f2-2482-4f14-c412-08da69ddd794
x-ms-traffictypediagnostic: MN2PR15MB3520:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KsfbbUybZtiq3FlAaUOB4aY5IOSZzsMTJNg0t7EWzP/p/a9DGv01im3okuHdjT1XRjqYB3BeWQgFyssPhcoR/Edt9ktDU4JZkGAIBaF7qntZPaYsSI8PDzmfPSgvWFWB1ChcKNPhB9vifbmhfXYFBeEKNa8CoycPOk0Re4UDgIAT+uq6Og7Eec8X2uju3EOwLulNY8zeOB0FPHQQF0JFKHRZX2p65zO6oJW1S7V9Ld+5/4TuDl1O/FEnpWn0XAtkLYVZCWmLq2LbgWDPAUZPKtm1OWdFdP+nYBcfKnpmAe5xmyWJoox88AeBDKq5vgSISM1n9nh29cYuk54bXSq8NoeIxODY/MQpAtD0sX4+oOupW26JV2nhSMBELbz33SgAfZ5eLvHJINaHoyAFLfX/bjfHioqIUFCDDNiS84ykn8b4AYS/rFEMXdHYvxpXVenJ7saf9UcuK4nQmH7tREmd7+vNj8Uv19u+P7fU/B4xD/dkXt6lCHAXdJ91YshCHr9K2cSlqdNDv7fc0mVolKqaswf1RljAV1RSiDmHJl50EkaRvTDrcGO5lv1AeTsVr4uOfrkCtr6vTEZGFAPI0JvUkU45PiuohiEiSAULzZTNoM42AVcYVx+ehmMFVG0ZX+e+87edgigWGxTaHju3ho1G7rgZ0dGO0NZRWyQKTUWP4J0dcG8krG+1BKQTaQa/KWUoIxuiFJMHYBH+7fngldkFawhA7qnW1mT8K628pFJXxKYxpbBD8EN0wS8IyBlRFwRHuUpQ8zSNF2uRwlVFaPa2lM+n24GEwPjRoHFvQUJKQNB4X3PSSUTWq/R2QUT/GLEdAksT0Rml/ABdhPRNFELliQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(4326008)(8676002)(122000001)(4744005)(76116006)(5660300002)(66946007)(38100700002)(33656002)(2616005)(186003)(91956017)(64756008)(66476007)(8936002)(83380400001)(66446008)(36756003)(2906002)(66556008)(6916009)(478600001)(316002)(6506007)(53546011)(86362001)(6512007)(41300700001)(38070700005)(71200400001)(54906003)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iOXl2iDF1A7pkC1gKIyjJRC9eduOxH83QbCiavJLVAbO+mYI/74II0GxhyCK?=
 =?us-ascii?Q?vE9+2Jo18ppBE1G9w0RoSrgjh3aK9kpt8Zqa11V2XtxHMK89tKGHvxEMwifw?=
 =?us-ascii?Q?sebB6T7xu0kx7OqfeUxq8Ns7T21U0TRJx4FRX18R8aVY3629p4YaUpHgi0Zp?=
 =?us-ascii?Q?/Xw55Q73kDHKsIZSbnA53dLIEFJGWI+BxGY233I6bbojQ+UyDEWASLzxqF7f?=
 =?us-ascii?Q?MynlAEqMAf/O0GUrdalVrZp7ZoENNcZWTiJ4mJRXhIZHFZ6mFdErLwvpYwuW?=
 =?us-ascii?Q?qmGgXeQ2wjSb2I1O9mZdcLzRZEoR2zU8RdrfCZu6qXD3GIQOAFcTND4M1RfP?=
 =?us-ascii?Q?oyUObkM0HQO3vjpXl+bK9sRVJTHos7P6YDgeSXwKHlCBiapzDedSBf8egcy3?=
 =?us-ascii?Q?xGQ0Qo5fHAXagswKCTUuR7RfDdSxMakFrgKMFGBEqTEKElFLDe1Q0T1bmJ+f?=
 =?us-ascii?Q?wWelTTMOxZYHwB/UjA3oTAd9NtXyptna3MjL4U9kd/bE93kOGEtW1JvXohlA?=
 =?us-ascii?Q?43iRrdlisPQqRiYV54p7hqlw+5JBUMTfg/zBTb3HPj6+GodS5dfQDXBjwSsD?=
 =?us-ascii?Q?KZLL6cUk29n3AyAI2qD3fT3FRXfdSgxc6dTTSNVU4z4kgM176l2I3cqtacg6?=
 =?us-ascii?Q?NZcEx124peLg6lrr8+NksrcMNeXD5mkK1FThSDtJLWiG+9PeSb9D56NXuQbk?=
 =?us-ascii?Q?aTALRCmfOaVMrq3iihdSn20B0ZOL19pV4Ys4n66lOYozdqO0v+la9Bcg2zio?=
 =?us-ascii?Q?T7XB042fN9hx4eu7UrDY9lsxOpA+v31RYIv09GX1HthsQoIjML3DTyu59HVg?=
 =?us-ascii?Q?phZHOCHTN7BcZ1qTeiTPXTfeGkIwhFrBrTSfIlJDIAq7sZet80iQGDFSJIv4?=
 =?us-ascii?Q?//ghSTqZuo9dVlXUAA0l6KAnIvEY/AD8gXsbz//kGuZM2Z7TyFvANozZHtsr?=
 =?us-ascii?Q?/cKNREeMhVdoUiOtPbwJ5mIhV2vxnpYfnsfiW3jA02wAOy0dVbsdXUCO04qv?=
 =?us-ascii?Q?cC7WAC/5hKq1Njb4qUyGMKZMQuR/J/KouLjCD5mnzn0pJAmXzUTWEx11qJoh?=
 =?us-ascii?Q?3dlJuJ95zNoe3q2cZXiAdI1EZQHTiMBMI6fKhnaJGGDGOtevfRLN8264Twlm?=
 =?us-ascii?Q?QDSyKp/iLDRgrsN0XoHrJw8dCLxpbdJF1TCxGl5ugtIcjYzo7vhxgeXzCE6x?=
 =?us-ascii?Q?Pz92qC/e8z9GANYX6FjapZWm4OUmIlFky1b6TNr4pGC+2gha/USK/Q4HOndn?=
 =?us-ascii?Q?Ffmj0O/9bnrfDZlri4SnCIIn5t+qaAKCzha6O+AKXzeNX4mTuJcCyreL1OOt?=
 =?us-ascii?Q?KJxCHkHLoWIi6SkRCXBx2F1OCgRwqIvCZX5+Q5NEqQxsv98i2h908CbUbiZR?=
 =?us-ascii?Q?aX1KJA7m3/7XEY3a73wydRwBFNKoWY6orOddO4FzDOijkYTlm+vz0XNvodU2?=
 =?us-ascii?Q?Qu8XTPBy/f2q3vkP3/W+0iSfG5NZtxNeaj3TD0iJsEKnH4fjiBcpsDM+9SYM?=
 =?us-ascii?Q?5yQeEdwQ92flKob6vNE1BB4uRtXLLbvQRhcgVe2L3stElyoc4jfMFfz0FN8i?=
 =?us-ascii?Q?k5uHqQ1vN4Ml6/9PDnbT7+FIAd1G0eRd3jKZHwyo3QBSZNO4b/Hnd61xtl5w?=
 =?us-ascii?Q?2TpI7PvPY0wcUOcurwh10fc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7280954CE2F57749A1D94B03AC55CAFE@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e076f2-2482-4f14-c412-08da69ddd794
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 23:24:35.1574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3WJTWKRktA8Dbc565gI7ic2xl225Ae69jLsKpwTxYVbZ/5f+91QiUO7omXWZ0beHepzwDmrtccHDgfN53X5Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3520
X-Proofpoint-ORIG-GUID: MfuIDrrPAajzbWpaycKHwSBzag4Pkr_h
X-Proofpoint-GUID: MfuIDrrPAajzbWpaycKHwSBzag4Pkr_h
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
>> /**
>> * register_ftrace_function - register a function for profiling
>> * @ops:	ops structure that holds the function for profiling.
>> @@ -8016,17 +8192,29 @@ int ftrace_is_dead(void)
>> * recursive loop.
>> */
>> int register_ftrace_function(struct ftrace_ops *ops)
>> +	__releases(&direct_mutex)
>> {
>> +	bool direct_mutex_locked = false;
>> 	int ret;
>> 
>> 	ftrace_ops_init(ops);
>> 
> 
> I agree with Petr.
> 
> Just grab the direct_mutex_lock here.
> 
> 	mutex_lock(&direct_mutex);

Actually, we cannot blindly lock direct_mutex here, as 
register_ftrace_direct() already locks it before calling 
register_ftrace_function(). We still need the if (IPMODIFY)
check. 

Thanks,
Song

> 
>> +	ret = prepare_direct_functions_for_ipmodify(ops);
>> +	if (ret < 0)
>> +		return ret;
> 

