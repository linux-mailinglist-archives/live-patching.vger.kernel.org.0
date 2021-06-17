Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449BA3AAFE1
	for <lists+live-patching@lfdr.de>; Thu, 17 Jun 2021 11:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhFQJip (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Jun 2021 05:38:45 -0400
Received: from esa2.fujitsucc.c3s2.iphmx.com ([68.232.152.246]:11167 "EHLO
        esa2.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231252AbhFQJip (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Jun 2021 05:38:45 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2021 05:38:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1623922598; x=1655458598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ry49ZJBMZf+oRWIUdVQlrOtaScVUL5h5yhnTT232EW4=;
  b=GpxmpkagyC/qFgRAmb+p8bDW3c5RgSHTFFsSmWWOIa8PZSe41gphjMmB
   +qQguwzwxWnchaKByHsXIwMTMWYku1gCDMJ5cdUSKZ11pNnZ9JTw/356D
   0UkEgqkTlTe2gDLJ4NsB272mi68cSSZSZuyz8ViX+p4afhqJ4vfAAVZx+
   tzlXFxC+mPNQ9PNyr0jr8SbAnlSDpvQqcaOX88Lv0oAWMh6h6IugIzqed
   OIELOPWCWJpGfwtXAadogLB/+I/zhBBCqmzIhV5n+xM4PnJe0Ut5Qf2vi
   oOsDkd9797VGbe2Mp08y3bU3HnEiIjpADRGhpTrk3clGbk5BuytkmCWso
   w==;
IronPort-SDR: iN4SQi6djfdeqtnrJNCjLxrpdjhMS+lPS/m48guLpDSWbIh+OdsYCr02BrR7d6yugGh2jgssEO
 2yUeaN0GeyYX25f4nA6Se3Gm2hHdoz1Qy4n7Oqr9AB9mHx0LcxesIx+NjmvYEd/DYr9B1J0Syd
 q1kMLAL7Jmjz6W05MQVYiaGYxN5dRb1kaU0deTTFKVXnWpHX3pE6vZbzUSqQYDS2Ygl2cSwT7z
 d4AXMAdwWJCCYNI/MWgb8hS8nZg1D8whFx+0cMlvenXVAJsxPIGoEp2DTgpABgOjzZq/3Skt4p
 QGs=
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="41457790"
X-IronPort-AV: E=Sophos;i="5.83,280,1616425200"; 
   d="scan'208";a="41457790"
Received: from mail-ty1jpn01lp2054.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.54])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 18:29:26 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNPRaaojzuIcRmmGDZKKoChbB8f3e+1eR8xD9KVIuXxmD3CgMSBQIDDlXkfjpE2nAXFL3T9AhmUpR31A+4FXxrs5MX7jjAUhuNNmYraHm+4SY87EyWw/6EyzO9gkb/d0ManZjeKA1rt/b8jyuqB0Nn5Mixg3sVNXSfpyv6ZKj3vTI02G5KshGJ9kHwhjGpkGqtxZ6GihMVCzAGdlOEzlJggmcDGKT/bW543V7PIdX+T7bNKdSiBfWOEL9DBpTaCN7/hMqCCfNbrqsBTrFu/d2pXeMSg5LYsZbC4URCLrcdoA3Czqx8W0LubKR9BRPHW/AaRbIboyf7zJLW2jYHHOiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvIGxUQMaIp16x9JpvdnxQkAEgdbHma4DnvdJqzLkxM=;
 b=ZzibXZvNFMF2+HoJ/cSU4uLZLnQlAU3ECnKvHmJAI6HVP1ElugxVxWnP73xJSQNASk3LgVTpwsqaVqRlPjl+3KgydImLhC1SHUUXHC0x+jmq7zD39Rs1q4HbCdgW/2LUzfscmijjntuz5H+dIF3K59DzvsjZ7F6L9988l8n6bXUKNgBo46hMQI8Ynu9j/iBWajzm8qPK6ENQ0iE9aHvqwmMQ8KRnHYRhy+Uzq9V9z3uXB+qlkHRcITwqiOPAsRBtFuROyVSHjio6LUQGIMuvATJZ+vKVKVNlnEYa9in8mDo8jIoBxrFlNEe4sX43+da32L1a8qxk2Vz4wPBK1CabDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvIGxUQMaIp16x9JpvdnxQkAEgdbHma4DnvdJqzLkxM=;
 b=dQiMUiiR0cWCKuuEqFrhDyF/b79fkacLVjiLTqDRL0owrBqe7S3oWqyCC6hvlU2iE9szRp3QHtGiPsUF9hIf1AIt2YOlnUSxEb/ZcTehCwnx/D8IbPIhwLG7zc6BVB3OlSHC9lNKeC1+acRDdT/k/m9ZYicq4AfW3tjD5MbAEcs=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYYPR01MB6652.jpnprd01.prod.outlook.com (2603:1096:400:c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Thu, 17 Jun
 2021 09:29:23 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::1d6f:5a3b:9719:a811]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::1d6f:5a3b:9719:a811%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 09:29:22 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "duwe@lst.de" <duwe@lst.de>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH 1/1] arm64: implement live patching
Thread-Topic: [RFC PATCH 1/1] arm64: implement live patching
Thread-Index: AQHXWZ3CD4noxF06h0yjyXLanHsV4asX+OWg
Date:   Thu, 17 Jun 2021 09:29:22 +0000
Message-ID: <TYAPR01MB526348C06BB8E410DF8CE3D3850E9@TYAPR01MB5263.jpnprd01.prod.outlook.com>
References: <20210604235930.603-1-surajjs@amazon.com>
In-Reply-To: <20210604235930.603-1-surajjs@amazon.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-06-17T09:27:36.881Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [210.162.30.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46cb9325-e55c-4894-cddb-08d931726463
x-ms-traffictypediagnostic: TYYPR01MB6652:
x-microsoft-antispam-prvs: <TYYPR01MB6652BDDE91119374E70BC143850E9@TYYPR01MB6652.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FSJEzN6SGGL2omjSMQ+j71DhfavmqQRtl3pFamIf2rOD6Biuivl3R3pjSzJ0kidlKO7MOzfdo3Sf2zKqfqP+YybkoVYZ7aEiOfqi9G47eUbOwYv6K8E7rSuhhmgPYhOkO5bruMb9Nrm5cyo5CZB3YYfgelGtpoC6/qJZPXGGlxXN04zR8Jvjy7KgBm8w86JVluGkzYy0pgV3hf3vrZZBTgCVIcNahffetCdK6TXzr/lUEp6r6JMtApVFceqJdQ4lBC+dE7e1Nx0++aWwRK7SC9r3O2UE0lj/9xgiiszLPvCYsWgdQeR9U8ChBp6bCia1zmSToNS/XABctle5uwtuQJQTU+BbvEWIW423rn9K2jvobRjQTJx+5w65Qn6vFQfbhiaebXyWWilwpXWxg2TsJddumtsgyCoGqzAaDIH8Jz3mAr9mKfAFEV0XXX2Gp8Xh6a1t0jV7EK05uFzCghMi22eLxE240+FRQSj3xQNIWqZIfqHY9VO7pSmLrLOFWukR7rjzfkK4OAMtKVXoZ7ytie7q0Zdgb39Bql5erb67jV3NeXzeDqgwrUXrkRxukVrUa5PhMU/MUuD3RJ0HComxcTC9x9V31ootCbixdo0a12yz67Dkh6Lrf2Py8t2OSgGL5uyE43C+I3ZJPCTFOHEUSQJimuoiBN4y4cRA8IiV9op7ViwKc0iTC1JP75rmaMZkO3evbndugRv2UjtCnJMjtT6I7G7f4JFDWDlU4UQdxKyU81GxBC55cXXlWQDew+sr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(38100700002)(122000001)(66476007)(66556008)(76116006)(33656002)(66446008)(45080400002)(66946007)(64756008)(54906003)(316002)(8936002)(71200400001)(478600001)(9686003)(86362001)(966005)(91956017)(4326008)(6512007)(85182001)(6486002)(8676002)(5660300002)(2906002)(52536014)(6506007)(6916009)(83380400001)(26005)(7416002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?dHV4b1VjNm1aWXlmclZCNjh3blNMcjNWSmJIVmNLZnlYWmg4S2Y5QWVT?=
 =?iso-2022-jp?B?dURuODhGSnU1YTE4MmsvWjV5K1dhSGJOL0hJSUFOZnk3SVo2clArRm5r?=
 =?iso-2022-jp?B?MEhDajhpc0dlaFhwcVY5enFqR3k2RWhXWEYyY3lLMEJFemVaZmJNZ09X?=
 =?iso-2022-jp?B?alBIMEh6TmdoUnRBYmdiL2R0ZDlMQjE4bmdKV3RiUGxwN0tJTzVsRSsz?=
 =?iso-2022-jp?B?QWFXTFVvN3dkb3pjaTVtRmVDeUxzbmhKMGVRVVZUbUw2TDRPSHRvQ3Zz?=
 =?iso-2022-jp?B?YnVXRHdLYXpNR1VwcDIrOEVkdWt0eHJDcXlTei8vZ0x4WDBhVXNYYlB5?=
 =?iso-2022-jp?B?S1lHcnVXS1VvUkplZFViTlpuMXM2U1k3YlVpd00ydWRXTHBrcEFzV3Ey?=
 =?iso-2022-jp?B?dUNpSDZDT3g4ak9zVDVseGlZTU53Z3lteE5kZ1hZRW5mcFdCNENZc0ZU?=
 =?iso-2022-jp?B?bmlPRDhxSk9NUzJSMlBqOW01NW9XajZKTmU2TVJod2x4TmxGVEZ4Ylc1?=
 =?iso-2022-jp?B?OVFiNUZNT2F4MC9vTE9WZStSa0tXK1VQM2lMbGZxS0pZeWJmRzJjMkNU?=
 =?iso-2022-jp?B?a0xBb09DVXl3R1RIREQyejlGWHdmdnZnL3h4eHAzSTZoazMvRDZvNFlY?=
 =?iso-2022-jp?B?aDJRSkgzZzB1NXFoRUpzdEN0dXJJcXFUOVZnbEN2RDhac1Z6anBJWFQw?=
 =?iso-2022-jp?B?VEV2Z3grVmIxL2hmM0NYTjdxZE5NUVlxTEFiYTJzcGRZUXNuSTBjWnFB?=
 =?iso-2022-jp?B?aElBVU44TXFqaG96aVR3Um04VHZ0aS9xcDZJNFlvcXQ2YVZvSHR5Tk9K?=
 =?iso-2022-jp?B?V3pKaXFpaGNVcGl2TmFacFJFeHhucWVLYlRwK2NlTlhqY3Z6czBjdzlT?=
 =?iso-2022-jp?B?a1JFb0cvTjRjQ0RNTEtkR2VLOHhWZjlrNjlYaFNZSHhtVXpNcis5YS9P?=
 =?iso-2022-jp?B?S3pKVk9WcTROOWVwKy9EQXZycWpkZUIrQ3RqRnc0R0VaS3drNXp5TDlO?=
 =?iso-2022-jp?B?aTEwWHpvVlY3amNVMEsrUEJmRDZoN3B6MXl5ejZuTmJzN0dXemR2SXNk?=
 =?iso-2022-jp?B?OFYxK2taczFaWTUxTzlRM21HNjBNckZmL2wycHF1WTJmVmo2cGRNYUlk?=
 =?iso-2022-jp?B?UE1TL0JTQkNZRlFUOVVTbUhybW0xNjNGNnd6QmJSclc5VmdlR053NG1I?=
 =?iso-2022-jp?B?ek1EUnRCU2pMYnlBOXJqQWNvWXVCWDhTWmJOSnhsMVRJS2JoYXp4cXZ0?=
 =?iso-2022-jp?B?dEdIcGNZZlJSUlpZZG02NktHU2l5UHJHUHk1Z2hHK2pwR1g4b3FNdzlP?=
 =?iso-2022-jp?B?YXh2dmVwN3ViRkFDbjJYTFdDWDQxUDY0dHB2d0o2ZU5VeWtFRGJONzBN?=
 =?iso-2022-jp?B?ME9VdEVtRTZCUVNYRisyUTAxcktUT1FrdFJWd0pLc21kYWZrZm5XRjVX?=
 =?iso-2022-jp?B?Q21FWUpjekFWUGcvRjdKaXh5ZGF6Y2dYV3pCalNtTUhjTkF4TnBBcXlN?=
 =?iso-2022-jp?B?ODQxUEJIL1FFUlJVOFlwMS9ZUW10T1Y5TjFhUGp0dVRPNlFnSEtlMWR6?=
 =?iso-2022-jp?B?cXZGdHU1bDRRRCtOZUd6S09FK21MVXJpbzBwNUE2NnpyaysxYnVYQkdQ?=
 =?iso-2022-jp?B?MG9JZWN3dzBLSWY3YXJnb080R1dDRE52S3hSU1pwTjRkYmd2dlcwa1Vt?=
 =?iso-2022-jp?B?RWNOallKMkFaM2N3ZCtyRytRVnNabjNxSnhNL0dGcGlrUXV2d2FHZzhD?=
 =?iso-2022-jp?B?R2FoTVRsMW9NOEtFMCtiZ0xJc0FLTWNBVXROYlFFYzlrTDJQa21DNTZU?=
 =?iso-2022-jp?B?TUFvcHh0M21wY1dBU3hEeXNYVzR4K0Rvclp4TXhMRHltdUxsZU5hV3RF?=
 =?iso-2022-jp?B?RUVTcVdoR3dTMGlFcE9DTEhlQVFvPQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cb9325-e55c-4894-cddb-08d931726463
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 09:29:22.8831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ev8pCJRrKV1Sd+P2jKFOyExC/JkZFKTFG62yVl2UfR6k4lEzisd7iso0fww1KJ/f+obAMbjJz2pAXpqagjwqWvQueyeCvJAomo2u/4eCPVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB6652
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

=0A=
> It's my understanding that the two pieces of work required to enable live=
=0A=
> patching on arm are in flight upstream;=0A=
> - Reliable stack traces as implemented by Madhavan T. Venkataraman [1]=0A=
> - Objtool as implemented by Julien Thierry [2]=0A=
> =0A=
> This is the remaining part required to enable live patching on arm.=0A=
> Based on work by Torsten Duwe [3]=0A=
> =0A=
> Allocate a task flag used to represent the patch pending state for the=0A=
> task. Also implement generic functions klp_arch_set_pc() &=0A=
> klp_get_ftrace_location().=0A=
> =0A=
> In klp_arch_set_pc() it is sufficient to set regs->pc as in=0A=
> ftrace_common_return() the return address is loaded from the stack.=0A=
> =0A=
> ldr     x9, [sp, #S_PC]=0A=
> <snip>=0A=
> ret     x9=0A=
> =0A=
> In klp_get_ftrace_location() it is necessary to advance the address by=0A=
> AARCH64_INSN_SIZE (4) to point to the BL in the callsite as 2 nops were=
=0A=
> placed at the start of the function, one to be patched to save the LR and=
=0A=
> another to be patched to branch to the ftrace call, and=0A=
> klp_get_ftrace_location() is expected to return the address of the BL. It=
=0A=
> may also be necessary to advance the address by another AARCH64_INSN_SIZE=
=0A=
> if CONFIG_ARM64_BTI_KERNEL is enabled due to the instruction placed at th=
e=0A=
> branch target to satisfy BTI,=0A=
> =0A=
> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>=0A=
> =0A=
> [1] https://lkml.org/lkml/2021/5/26/1212=0A=
> [2] https://lkml.org/lkml/2021/3/3/1135=0A=
> [3] https://lkml.org/lkml/2018/10/26/536=0A=
> ---=0A=
=0A=
AFAIU Madhavan's patch series linked in the above [1] is currently awaiting=
=0A=
review by Mark Rutland. It seems that not only this patch series but also t=
he=0A=
implementation of arch_stack_walk_reliable() at the below link is required=
=0A=
to enable livepatch.=0A=
=0A=
https://lore.kernel.org/linux-arm-kernel/bf3a5289-8199-b665-0327-ed8240dd78=
27@linux.microsoft.com/=0A=
=0A=
=0A=
>  arch/arm64/Kconfig                   |  3 ++=0A=
>  arch/arm64/include/asm/livepatch.h   | 42 ++++++++++++++++++++++++++++=
=0A=
>  arch/arm64/include/asm/thread_info.h |  4 ++-=0A=
>  arch/arm64/kernel/signal.c           |  4 +++=0A=
>  4 files changed, 52 insertions(+), 1 deletion(-)=0A=
>  create mode 100644 arch/arm64/include/asm/livepatch.h=0A=
> =0A=
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig=0A=
> index b098dabed8c2..c4636990c01d 100644=0A=
> --- a/arch/arm64/Kconfig=0A=
> +++ b/arch/arm64/Kconfig=0A=
> @@ -187,6 +187,7 @@ config ARM64=0A=
>  	select HAVE_GCC_PLUGINS=0A=
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS=0A=
>  	select HAVE_IRQ_TIME_ACCOUNTING=0A=
> +	select HAVE_LIVEPATCH=0A=
>  	select HAVE_NMI=0A=
>  	select HAVE_PATA_PLATFORM=0A=
>  	select HAVE_PERF_EVENTS=0A=
> @@ -1946,3 +1947,5 @@ source "arch/arm64/kvm/Kconfig"=0A=
>  if CRYPTO=0A=
>  source "arch/arm64/crypto/Kconfig"=0A=
>  endif=0A=
> +=0A=
> +source "kernel/livepatch/Kconfig"=0A=
=0A=
I think ` source "kernel/livepatch/Kconfig"` should be placed between=0A=
`menu "Kernel Features"` and `endmenu`.=0A=
=0A=
=0A=
Thanks=0A=
Keiya=0A=
=0A=
=0A=
> diff --git a/arch/arm64/include/asm/livepatch.h b/arch/arm64/include/asm/=
livepatch.h=0A=
> new file mode 100644=0A=
> index 000000000000..72d7cd86f158=0A=
> --- /dev/null=0A=
> +++ b/arch/arm64/include/asm/livepatch.h=0A=
> @@ -0,0 +1,42 @@=0A=
> +/* SPDX-License-Identifier: GPL-2.0=0A=
> + *=0A=
> + * livepatch.h - arm64-specific Kernel Live Patching Core=0A=
> + */=0A=
> +#ifndef _ASM_ARM64_LIVEPATCH_H=0A=
> +#define _ASM_ARM64_LIVEPATCH_H=0A=
> +=0A=
> +#include <linux/ftrace.h>=0A=
> +=0A=
> +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned l=
ong ip)=0A=
> +{=0A=
> +	struct pt_regs *regs =3D ftrace_get_regs(fregs);=0A=
> +=0A=
> +	regs->pc =3D ip;=0A=
> +}=0A=
> +=0A=
> +/*=0A=
> + * klp_get_ftrace_location is expected to return the address of the BL t=
o the=0A=
> + * relevant ftrace handler in the callsite. The location of this can var=
y based=0A=
> + * on several compilation options.=0A=
> + * CONFIG_DYNAMIC_FTRACE_WITH_REGS=0A=
> + *	- Inserts 2 nops on function entry the second of which is the BL=0A=
> + *	  referenced above. (See ftrace_init_nop() for the callsite sequence)=
=0A=
> + *	  (this is required by livepatch and must be selected)=0A=
> + * CONFIG_ARM64_BTI_KERNEL:=0A=
> + *	- Inserts a hint #0x22 on function entry if the function is called=0A=
> + *	  indirectly (to satisfy BTI requirements), which is inserted before=
=0A=
> + *	  the two nops from above.=0A=
> + */=0A=
> +#define klp_get_ftrace_location klp_get_ftrace_location=0A=
> +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)=
=0A=
> +{=0A=
> +	unsigned long addr =3D faddr + AARCH64_INSN_SIZE;=0A=
> +=0A=
> +#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)=0A=
> +	addr =3D ftrace_location_range(addr, addr + AARCH64_INSN_SIZE);=0A=
> +#endif=0A=
> +=0A=
> +	return addr;=0A=
> +}=0A=
> +=0A=
> +#endif /* _ASM_ARM64_LIVEPATCH_H */=0A=
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/as=
m/thread_info.h=0A=
> index 6623c99f0984..cca936d53a40 100644=0A=
> --- a/arch/arm64/include/asm/thread_info.h=0A=
> +++ b/arch/arm64/include/asm/thread_info.h=0A=
> @@ -67,6 +67,7 @@ int arch_dup_task_struct(struct task_struct *dst,=0A=
>  #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */=0A=
>  #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */=0A=
>  #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */=0A=
> +#define TIF_PATCH_PENDING	7	/* pending live patching update */=0A=
>  #define TIF_SYSCALL_TRACE	8	/* syscall trace active */=0A=
>  #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */=0A=
>  #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */=0A=
> @@ -97,11 +98,12 @@ int arch_dup_task_struct(struct task_struct *dst,=0A=
>  #define _TIF_SVE		(1 << TIF_SVE)=0A=
>  #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)=0A=
>  #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)=0A=
> +#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)=0A=
> =0A=
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \=0A=
>  				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \=0A=
>  				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \=0A=
> -				 _TIF_NOTIFY_SIGNAL)=0A=
> +				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)=0A=
> =0A=
>  #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \=
=0A=
>  				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \=0A=
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c=0A=
> index 6237486ff6bb..d1eedb0589a7 100644=0A=
> --- a/arch/arm64/kernel/signal.c=0A=
> +++ b/arch/arm64/kernel/signal.c=0A=
> @@ -18,6 +18,7 @@=0A=
>  #include <linux/sizes.h>=0A=
>  #include <linux/string.h>=0A=
>  #include <linux/tracehook.h>=0A=
> +#include <linux/livepatch.h>=0A=
>  #include <linux/ratelimit.h>=0A=
>  #include <linux/syscalls.h>=0A=
> =0A=
> @@ -932,6 +933,9 @@ asmlinkage void do_notify_resume(struct pt_regs *regs=
,=0A=
>  					       (void __user *)NULL, current);=0A=
>  			}=0A=
> =0A=
> +			if (thread_flags & _TIF_PATCH_PENDING)=0A=
> +				klp_update_patch_state(current);=0A=
> +=0A=
>  			if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))=0A=
>  				do_signal(regs);=0A=
> =0A=
> --=0A=
> 2.17.1=0A=
=0A=
