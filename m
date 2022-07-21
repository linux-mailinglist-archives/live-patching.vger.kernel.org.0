Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B54057D196
	for <lists+live-patching@lfdr.de>; Thu, 21 Jul 2022 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiGUQcq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jul 2022 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGUQcp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jul 2022 12:32:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B9B474DB
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 09:32:44 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26LG8hiT012657
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 09:32:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=pFJc535Gn0mm53C2vDNCgw3H/r5wFg+tl7zL+tgqgfQ=;
 b=UXQKHF/gN62dsEkZFCEgvDJzq1gpwSLp8pQs3gfh5snMHOzL+Kg07ZpC65U45LCWFDJm
 T7Y8z4U2Ft8pZQqr0KO5b5/oIKXSpTeY0hxyV+r8QHIcqbbChuwqi+FBikeKchAd4fni
 eEYHAQD2YMAZ0XJFgkl225rS0HHuWy2kwRE= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by m0089730.ppops.net (PPS) with ESMTPS id 3heut3cjwd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 09:32:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWRHDxO2U9YdBuhf+gSlCVH9uK2f+0AhDBk3O/5tB9jZlHFnXML+AhQz+0dRluxAhnKdylJgmFd6g+YTEZsC0TBgFy7T4PK0kETTi/ZWLffXrpGkaLEJZa4m2hQ350VNs542Tw1xOhvDetaL3vBAPEix63SE9Tk0RKd8SCw9lNbDAhNyO/ztl6TnjIeCyzbxJc25/JlcM+5uINMlRd9IGQ+UDcUCIww2/4kJ5KUFR6ZnJcdhaarYmoCWao4TcDITmUvaPIHDvTBKk96AL0qC4TEWtIplcCuP/bMmYFhRvroj0jR/q9SBdCRmaPVYTqRTrl6wFNVQUoyMdxwGYlfScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFJc535Gn0mm53C2vDNCgw3H/r5wFg+tl7zL+tgqgfQ=;
 b=Fw8hUpHmfmR1T6AXvMtDsoSKiVUAHHz4yLCYguG2hfOnUzm4cNpp1bzJ8uLcAtBALlOoGJiKye9z6iUp6eC15U5n1bc8D/e5gw6iJjXnmmInIdhTUcl2+f88C3bQQ5kdfaJsIo5Y06k6BjL9jJjVYeUZdDH8N3XzKdmrbJqK4nPcwqh0SKnJmYBUECsunpehHCefU2VDGKhqkJRrgSsL9DyVytyjygA1RsgAj5tQXGc/otCEoKFgqKLQJHFnoA/qw6x+0wJpLVfjTgKC04pwhp4XFsJRETT0n0J2dKN44q9PuDNCsVmNQ/o//VL4Z4pKHHwD1TlQOKpEOc2YzcI8OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB4651.namprd15.prod.outlook.com (2603:10b6:303:10c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 16:32:40 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 16:32:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Miroslav Benes <mbenes@suse.cz>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Cheng Jian <cj.chengjian@huawei.com>
Subject: Re: unload and reload modules with patched function
Thread-Topic: unload and reload modules with patched function
Thread-Index: AQHYnM8ssHgVdjWTl0ysVic6XE9f2q2IvESAgABJF4A=
Date:   Thu, 21 Jul 2022 16:32:39 +0000
Message-ID: <BA57CC88-D180-4927-9916-2B177DBBE134@fb.com>
References: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
 <alpine.LSU.2.21.2207211348060.1611@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2207211348060.1611@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3508fbc1-532c-49db-0655-08da6b36a0fc
x-ms-traffictypediagnostic: MW4PR15MB4651:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MPje8mzM0/Ifq1wK8YhhydalO1d6WGL1DRrMoZ8GqaTufaX/8u7PFCUMlT8Fr76jhP38ij8afG1pLaTMA3LC6d7Y7OMwbI7u6/dPizXaCBYAfdDofHjXBsRKkSYQIOtONDbiTvMq77XWdn21XX50Qj8PRuNG+5vmsTeStMpg5WiNK7lY/1NL8A8BR1y4L5pIVgN4JKrcqUSawy2pY6Coi6IWUI0Hdi6kD0VyCM8ygDnViI6l+xIkzmzSPTz+cqP4WX0p5V8OD3Kip+azgPEz88Qb8w7VWssnebTtrbivLnIJ0lFRImTWdBA+jctaege6hYfyTyDpv6BbUxn78LBeBK5b/Txq+fpiyqxYzgamCUjrgg2cfHZHQ78YO6UZOlLAbygt4VehAf2pmcB0l6ZYCRJwpSPw0CYEziZny09gXlZKjRIxqzEZwEmT1+o614hzkYCSMKfZh6P47yfJ/J6LOgEfR2m1ryw9p/KvQLYkfv3xBEhD3G/xL1uCHkhYlHnsrOMlRcvubwuKiTtq8TlGLEZWtolaM62nwOxqyt1QuSiUPeZGRDQ9O9rnDtgTaJTTpaaFg9I4ymOLIllmzrtHIyU3boxBM1n4WL5cuJ04z4pThr4tMiPWbUkpZ7n0+YENx+G8bbu6SXK4H5nLUWdinZB/hkDg7IJmbbyK0UIpHlOJspa1LkBRiZlv9Nxxx82vPhtOpiqI7QiKqhihQ++mLplwl5k9ne4AFbFPj7q5/K6rr7+Z79gcOpG2Ch0li48qFaP6O2mB8cykREv2cgkYecc7QQhq1Zg+lsHeUw9OgpKXl7lV4MHA160a+rZ+1qzozMSSedMuLVGVAS/vscNXL8P22405gcEL8Fmz1oB41mAmTwXuq3TOousnhbfBzLVa0EC8cSH97dIeevoA730cYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(38070700005)(5660300002)(83380400001)(36756003)(91956017)(86362001)(8936002)(6512007)(53546011)(33656002)(122000001)(186003)(38100700002)(2616005)(6506007)(64756008)(41300700001)(54906003)(71200400001)(316002)(6916009)(6486002)(478600001)(966005)(66556008)(66476007)(66946007)(76116006)(66446008)(8676002)(4326008)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bGvf/B/HpDY5wqNbqw7GNC08KefUgLeim8shM7+p+4Vn0BPkZX/d42J6Z4HM?=
 =?us-ascii?Q?0fGr0UI828ktDrjkBSLZJqFveysYSKZAvLcon0izH14VB6mV4aVIXrISWqKJ?=
 =?us-ascii?Q?FXpCT9Lp3GCVZc1DbzSUgqmiKeFGv9lsNMcV2Zntl5lqDVdS+/4meKphPlfz?=
 =?us-ascii?Q?EeL1cB9FhF/kIEwxzF2ND8Oga7PRLo+oviU5hpd6UguaJ7v1ZxYIuKqblNXv?=
 =?us-ascii?Q?J33AKc+DpuP/Lm+6MZO2JQfJV2OrvfeVv6gZLAaSpferZT+tto8wnKJotNzF?=
 =?us-ascii?Q?WwrmN5DKpjshAGwww+6Kk5t2QTmfu41GwmMAgFDdNao8t3DiMGdhjSvd/TDk?=
 =?us-ascii?Q?KD6FshkNXvtw8olABBfjqsEAiWjRM28Y4vFdrQ4xeDqIYifQVH1919dA2+rS?=
 =?us-ascii?Q?8C+EdfjMogmIESuWzWCVWwG7lFxy2O+fJhYwYu10qyJX2WC2ZF9cf/2cbnEz?=
 =?us-ascii?Q?3Fx/0uMXwfIGaxYGbZixNohuTkSt3fmOLsx+Q0U2PfD+uaqYylFZflM8tchh?=
 =?us-ascii?Q?rR7bw+BhkHhdG+MBn1aRjLSUdKNmxzp0ftdtV82ow0FR3jnu/7tSSQv6iXOd?=
 =?us-ascii?Q?QLDZG0fRSYrdY61VJPLSkvmrehENmzo3lNchrtoEJJDcp2HvfQQffADDy6az?=
 =?us-ascii?Q?4OYiHCkSdqhXiYY8s/dYBOtkJr0JsaevsuRFL6qBNngIEilO2n891JEEl2wQ?=
 =?us-ascii?Q?1Luw+FytY+T+IV1OYfiFwWCXYEEc1JQVzvHhBLHlejg6ruordy6VqRcfwkKv?=
 =?us-ascii?Q?MNgUIBKvjP2jyymm1h5xxfYg0/BXxlNFF4YO125VplVriNB8sa6Jxa7esCJz?=
 =?us-ascii?Q?I8oQ2VlXv62hPNaN4T4JK9FIeQm0sTBd4pxKThN4L8eqrRlehOfP5OjBQ4ZY?=
 =?us-ascii?Q?6UH7XzROb27eK58Y26SZJlQujM1zGbmVYILK9CWqWFi82BEzQwRr2qNLg37o?=
 =?us-ascii?Q?7sfcG1mVZUbNzFBqchqYZpXikJ60P8ARjva0QKn1J0UraXiq3CKlPNDDH4Wx?=
 =?us-ascii?Q?LXFi8AEpvPwYU60sOkm1wBrAnJXzS6d5DUAj+jyc0XXZ0OcDFp1nMTOHhdfb?=
 =?us-ascii?Q?Pk/N1ysNtenbXz+VV4250h9+6c+WiCUzYOG5hirGjb7rUCUDYKRX5wXOdnHm?=
 =?us-ascii?Q?RA9GGt1ZTlnJ7pnAChxkuKhWSVC74amS56GhVO0YFM8Y2nATlhwrc0Rl575A?=
 =?us-ascii?Q?MAdqo4AHbnUOe59+6zfv5C8y73k+peXbnaNF2V628OoxiCvQDTAd/MSOg2FA?=
 =?us-ascii?Q?WkXNjrWGAfmLd0PvZkqSiywTHRJzT8GOspg3Z/xDg7JG101E+Ih5YjdVPL5b?=
 =?us-ascii?Q?RSbADO3gP7Qmbg5n2obmW/50kTTbJn1JMPlC0ISwDwS6sp2igQaEXvdiiFRO?=
 =?us-ascii?Q?AbsILUSpxkb1xBQkBUs5tb5hAGPQ+7ExX8o3IXadStrK6bupWjBm4AnIAWHt?=
 =?us-ascii?Q?iAw9bGPU/iwE4nFLl7q3oF5O9dEvS50J2W4gWxAOc0pW6d5zcCaIPCkFOw6s?=
 =?us-ascii?Q?O6QSUe3gB6tPRopnbxjKeSNfK/PJ6jzYCErkC4IbPEPrkdAFAI0gs/hQzXUs?=
 =?us-ascii?Q?2zC8pDWm25DWfUFOLmFdZqt0oxaCLyzE18v2DPEvIW7zHr3AGvUjmEP/sAE7?=
 =?us-ascii?Q?wKkEA9z5x0le1lAawJiauOQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2A3CAA13B0AA342A1E3B6F89AB7E06A@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3508fbc1-532c-49db-0655-08da6b36a0fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 16:32:39.9155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nAMfO04sxOfWKKoBrxOnlY7SEDHPeisapAitwHkOo6NSgvrcqx4PcLfAqm5YjKmp83n+UitB1NYueaMho8uDtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4651
X-Proofpoint-GUID: oSiFnSPCkg_oH3iCZ-XREKqyGIzy4mRa
X-Proofpoint-ORIG-GUID: oSiFnSPCkg_oH3iCZ-XREKqyGIzy4mRa
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_23,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Miroslav,

Thanks for your kind reply. 

> On Jul 21, 2022, at 5:11 AM, Miroslav Benes <mbenes@suse.cz> wrote:
> 
> Hi,
> 
> On Wed, 20 Jul 2022, Song Liu wrote:
> 
>> Hi folks,
>> 
>> While testing livepatch kernel modules, we found that if a kernel module has
>> patched functions, we cannot unload and load it again (rmmod, then insmod).
>> This hasn't happened in production yet, but it feels very risky. We use
>> automation (chef to be specific) to handle kernel modules and livepatch.
>> It is totally possible some weird sequence of operations would cause insmod
>> errors on thousands of servers. Therefore, we would like to fix this issue
>> before it hits us hard.
>> 
>> A bit of searching with the error message shows it was a known issue [1], and
>> a few options are discussed:
>> 
>> "Possible ways to fix it:
>> 
>> 1) Remove the error check in apply_relocate_add(). I don't think we
>> should do this, because the error is actually useful for detecting
>> corrupt modules. And also, powerpc has the similar error so this
>> wouldn't be a universal solution.
>> 
>> 2) In klp_unpatch_object(), call an arch-specific arch_unpatch_object()
>> which reverses any arch-specific patching: on x86, clearing all
>> relocation targets to zero; on powerpc, converting the instructions
>> after relative link branches to nops. I don't think we should do
>> this because it's not a global solution and requires fidgety
>> arch-specific patching code.
>> 
>> 3) Don't allow patched modules to be removed. I think this makes the
>> most sense. Nobody needs this functionality anyway (right?).
>> "
>> 
>> I personally think 2) is a better approach, as it doesn't introduce any
>> new limitations. (I admit that I only plan to implement the fix for x86).
>> 3) seems easier to implement, we just need the livepatch to hold a
>> reference to the module, right? But Miroslav mentioned there are
>> some issues with 3), which I can't figure out.
> 
> If I understand my notes correctly, 3) as implemented would not solve the 
> following scenario...
> 
> 1. a live patch is loaded, it contains a fix for a module M which is not 
> loaded
> 2. module M is loaded, relocations and things are applied for the live 
> patch, load_module() on M fails later and it is not loaded in the end.
> 3. another load attempt of M would not succeed.

If we just hold a reference of module M, this would not matter as module M
is freed on load_module failures? Did I miss anything?

> 
> I am not sure how real the scenario is, but we also deemed the original 
> problem as improbable in practice.
> 
>> So, what would be the right approach to fix this issue? Is anybody
>> working on this already? If we can agree the right approach, I am
>> more than happy to implement it (well, x86 only for option 2).
> 
> No one works on that as far as I know. I abandoned the patch set for 3) 
> due to the reason above, and then even the patch set for 2) because it 
> was not nice to put it mildly. We decided the problem did not exist in 
> practice (till someone says otherwise).
> 
> The thread mentions better late module loading infrastructure. If I 
> remember correctly, it did not happen in the end. peterz removed all 
> issues with the late module loading we had because we had misunderstood a 
> couple of things.
> 
> Now 3) was submitted as 
> https://lore.kernel.org/all/20180607092949.1706-1-mbenes@suse.cz/T/#u
> 
> 2) as
> v1 https://lore.kernel.org/all/20190719122840.15353-1-mbenes@suse.cz/T/#u
> v2 https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u

I guess we can just ship v2 (maybe with some minor updates). I will give
it a try. 

> 
> I also pushed all I have to 
> https://git.kernel.org/pub/scm/linux/kernel/git/mbenes/linux.git/. 
> Branches klp_deny_rmmod* and klp_clear_reloc*.

Actually, both versions look good to me (I haven't done any tests yet). 

Do we have any preference on which way to go (given something changed
over the past 3 years). 

Thanks,
Song



