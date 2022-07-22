Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F5A57E4DE
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 18:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiGVQxe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 12:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiGVQxd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 12:53:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9863FC
        for <live-patching@vger.kernel.org>; Fri, 22 Jul 2022 09:53:32 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26MBEm9b016550
        for <live-patching@vger.kernel.org>; Fri, 22 Jul 2022 09:53:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=vLtmg44shxVnaSi3p7xu70M0+euBhMQto1alPadcZrk=;
 b=eijyWs3L2zbh/P/sCIqbjQJRxYqltEAx/7koDCGeB655P6cLo8lduZ1JKdTfEWnYiqXR
 qfMKHMomKEgTTQ0aTxHySiiZdi8FOjhSeSVh696Lt8LM1ujBk6v2n3phaiWafHYgaqdj
 YbudRZ2oW2opYjQKcKAG4SvO5Djbb8wnsQg= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hftudhtje-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 22 Jul 2022 09:53:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfdAbUgKO98AUzkQcxpsEwm0JSmD5JhgZWkKhVoGbSH6mTRs4AMAzolno5x9kAuRP682ujT+fMAUdNukZeyAt7J8Fd5A2qbYGv8Df/UBK5E7ZUsi5bji79tTF16HyLXfam13xaA8yHp6bOdSr5YfDwRMIpibsrtveplf3Yr/iq1QUR/fasFE0IQoElrxMiK3tF3JDC7kOKccu5SUTxe7SK0E2pX7wFrn3WJvq8vhQaSm0XAIimXH8b2TCB866MQplCJkz0Mfd++4MQnMqyTOjFQwFSur2BdFHVWIkkNwVegzQ8CObirpLjwN9QxVhg1EruVHh+1iC1kTp1rUtOfqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLtmg44shxVnaSi3p7xu70M0+euBhMQto1alPadcZrk=;
 b=c79eVNmLYRPVvbha3DjHr4EJ3nWQGdK+s5NnWOA+ct+QeLhoqq5cb1Gc0KFoDaPXu/pHqbPU/0ua1tUa1Z7oo7L0xLkjWn8GAToVIJ0vWRRyxYFF/8gG0anAwFP1O0RplthUbHhEAUs1BWz9w5RMRJPkmZhoSzcSFacGBJmaKwGiLUSMcBgdBXKs1BtgrMt6DD7VYgHjGJfRus0+UJ/QJyx3xnd4QWxFeFfVib8xguRdY6cEmrJuOKc8w+yRgbm7ai4xzawIH6XjhzdP7gDBR8leaGYZ/unzK4x2d4YladykpxdYFoiUUcf6tWdEEqv4JBUb+cM9wVLw1VJxdUx7yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2537.namprd15.prod.outlook.com (2603:10b6:5:1a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:53:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 16:53:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Cheng Jian <cj.chengjian@huawei.com>
Subject: Re: unload and reload modules with patched function
Thread-Topic: unload and reload modules with patched function
Thread-Index: AQHYnM8ssHgVdjWTl0ysVic6XE9f2q2KNXGAgABoDwA=
Date:   Fri, 22 Jul 2022 16:53:28 +0000
Message-ID: <914D9BAD-40D8-4D3C-BAE9-44B00222F296@fb.com>
References: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
 <Ytp+u2mGPk5+7Tvf@alley>
In-Reply-To: <Ytp+u2mGPk5+7Tvf@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33baa3b7-09c5-42e0-fbd7-08da6c02b3da
x-ms-traffictypediagnostic: DM6PR15MB2537:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v0/3SQj0S2tnRRUzO22E4lhy4pgLmH3Hn88aoB8Nb7YPUaNmCDQXM5+P/BIpFqpN5pX9TOzeFmFn+NQ1P+SpBuFM8txGbDr7k/VnLrvDE/SjpnEUpCdUxF43jNy0G99VXjesmOcGEHPkmu4snGKqCQLie3yLb997zR5Si+WX+XTsrCvnFvsuGtZC3F9xDMPQh2gEz7ViBfgsIxgSJ11WcShsehzy3K9vK9ArRsvcrDqwViCu5boNpRqJwhjpx9obT/R0CGlOrjhZHiEPsz7uYnTQVv0+oKNqyeGwvJmd/0cZr/OEU0jFoUx6indUOGfKv4curV51TKmSlwKzJL4Dh0HnCYM0Q9IkkrCug1j/1GqU0vY9wfCEZt20tjfRr54NHpKWFZ3f9yMVTqA1iXDp3OPgbn0P2E/8vC17eIyyVLJ+eQQYQYx/63dWnrBxYkoHxoNKWEu8EYPrBVpEnRMe/8D7CGCT+YfVXcrkO+HGsPx6bt/ydJ7X52973IvvhWwiv7VFsK3UOlPPaPy3eKhewDiv0I5yRkaOQ6U6bjUBnTOcnjLv4/yZHsvpGXzHhurvpPtN1usqu2/20qgqBm/B/Qg6CjoMn7ZD+rptq7sZ85VI+tn+TNHzSHNOtMWW9wyKQIiWeEcrTP9lLhUbu9OUI+gq2yn0/AqwQamfL7YmQPyCxzPsfkzLskT8zNrRuuBN3uqyBHHzMreNmQoBtlYHvgTy/KZh+V9/zcUcxXlyY6/nA1Zqm/NWu0IJntyupOCAHtB8Ege4/pI/sNFu5A/mwDnzttVsjgE1p7ukBFP27XDlSaJhxExczw0q5C55q4R1ToBO64k1ipO4vfkn3VdJMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(6486002)(122000001)(38100700002)(53546011)(6506007)(86362001)(38070700005)(5660300002)(2616005)(186003)(54906003)(316002)(36756003)(6916009)(33656002)(83380400001)(66476007)(8676002)(66446008)(64756008)(4326008)(71200400001)(66556008)(8936002)(478600001)(6512007)(91956017)(76116006)(66946007)(2906002)(41300700001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ik6BpMXJT0SoGSzy/rto8Dblm6C58bblRsWxQv37KEqM7SZf5iE/40OY8p6h?=
 =?us-ascii?Q?b48st5A2UD1QedQCNpdy30yD4qtkvIE9a0w5zNr+yvryxdQ1hYwjFa7cupX0?=
 =?us-ascii?Q?pDr/1EMqDhERsCx3EmQ4R2jF+nes19bpN3RSbe8aXkm+czuT2KwBnQuWCsJ0?=
 =?us-ascii?Q?T5pZPXGjoC4/IjydHLGttgICOoGgrrYm/pSibDvMRQ6d86vqsTiwp278Ek6n?=
 =?us-ascii?Q?QNAP6BiEAipILTbI8yOnDHXKNEk2FGYGGwNAcssG7KXHvcAk+amDS3X3+LMQ?=
 =?us-ascii?Q?sNfwFn+twUMNL3U4ZbY7HhE2prjaEPY3kjH+80pH/DkNvgzruxOOhkn2UEb0?=
 =?us-ascii?Q?AQhXKlrI/FCBUwywouhBXoTjCfzd896iKxbnDpYndVj4A3SAx4llEqP60huS?=
 =?us-ascii?Q?WO2Z74/3FvdtehVTtemotG5Wt4HT0VQvuNyHxUYVyXTMRhAHd1c1Jgtgo3dJ?=
 =?us-ascii?Q?JLaidtyWCqOj46PaeyuSFGrza/jt/uDvRZJOGnjK5MLR5MZhglSPLjiBsVqo?=
 =?us-ascii?Q?9xi+L0UkE/S2AJqb1b9XRCr2RgeuvsstD71eHE2ecOy8s9lCy7qX6D+lCv+H?=
 =?us-ascii?Q?pscY/ZFLS+90R7nKRacFFMvzLl1Me+PE7d+P1ZoMzS9rSPtqs2qPIdKPGX6z?=
 =?us-ascii?Q?kKOQsQQp1ovzs1rwftVKlsndl/+RCBJ2hmKFQ7VA2Y9erxxIgi5eBVtSb0af?=
 =?us-ascii?Q?qVo5WPfgP5ctFHIEEK1XWTbRLr5RQEifFkjvHLUfSeG3pnlRAgsTW8CMtlGV?=
 =?us-ascii?Q?8qmL7IjLcPI1SfRCq9zs7VhwwmEZYWTsF6A5efZAO8szyPVm3aJ8lmmjK7GP?=
 =?us-ascii?Q?05fRzMa1lB0AisuAMem0nz79tOsdUTraEaBouKVeW/7UXX08FwT9MJiZSt/g?=
 =?us-ascii?Q?CtkqWQIW8Bk7AKlA+gQ1NUIMAZVglumO74spdm7z0gFlTFLOuW93PmNJbbmT?=
 =?us-ascii?Q?wHLlY5hdUj+F1Y8L4t9eQ0ptZwWdqZtusAzYEcVTWT/g+CmKolaqWn/AtVCF?=
 =?us-ascii?Q?cR7o4mYdlURvywHhMpaRbzfbjkzaIcfSGdTUi2r427IqPz8pRvXHYkVE5u8Q?=
 =?us-ascii?Q?HfNxi3OpSzLDFqNHxMhW25Uf5WbwPz3xjulLQe/6yGQbxLh6H9E1G+8Yfk2J?=
 =?us-ascii?Q?GUHSVyjWeEJcQsu0xRfy3Dw1b7UWhv+GQqawOJUDoI4MqBB9Ssw8q/u3QdEm?=
 =?us-ascii?Q?gKyyPRwnS0eEo+1nP3JCxmOYjOWehEIIpTSzY9zPPkkrgOJ1H+dwGFnm1B2v?=
 =?us-ascii?Q?PiKxow0TQeClf0/KG0VtqvcijIWDSmUjJez4DQVUE5wP3LRCxIVYgyG8h79z?=
 =?us-ascii?Q?EIIWbDtAjG+WRc9/vfEwc6CV5sZpkvMjAURWQruGIg2OMEZqwA2wbqK9yL/u?=
 =?us-ascii?Q?3phlcKJ+ipDNKTaGABDfaleao3VcJ3MoDaX/oGWLXhWxswS/949n7npW8lWT?=
 =?us-ascii?Q?TqIVFYNzFWwXt/QT/6xGsAjVXGJ0y+HBcsyv/UMkO1IGK8kDwn43+WMgsgqO?=
 =?us-ascii?Q?aA54J87rf925zhfTf1jRG2rFz1yva75ToYXbvsu2eFAwbCfuFKk5U+dLqqAT?=
 =?us-ascii?Q?hndxSK9PzcPWBdERgkS6PXOMrpOv12iNkFumNrPcF77qDkZ13oXVrZlt17TD?=
 =?us-ascii?Q?+lIUnVm2B28v4qSIzVMWqXA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <788A5B213A02E84DB508DF67AD810DD4@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33baa3b7-09c5-42e0-fbd7-08da6c02b3da
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 16:53:28.8928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7HRLEwQkQ7EMMD5eFONoVRWZDvpd9L+m3lxklSb71AnCRMQpv/YNPnG93PaQJZfhkHbMNvHrHvYl9kAo6MeYcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2537
X-Proofpoint-ORIG-GUID: GXDXSJlbVRa5RmOpImma73bPCOkaCnz9
X-Proofpoint-GUID: GXDXSJlbVRa5RmOpImma73bPCOkaCnz9
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

Hi Petr, 

> On Jul 22, 2022, at 3:40 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Wed 2022-07-20 23:57:25, Song Liu wrote:
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
> 
> Just for completeness there is one more possibility. We have sometimes
> discussed a split of the livepatch module into per-object
> (vmlinux + per-module) modules. So that modules can be loaded and
> unloaded together with the respective livepatch counter parts.
> 
> I have played with this idea some (years) ago. It was quite
> complicated because of the consistency model. If I remember correctly
> the main challenges were:
> 
> 1. The livepatch module must be loaded together with all related
> livepatch modules for all loaded modules before the transition
> is started.
> 
> 2. If any module is loaded then it must wait in MODULE_STATE_COMMING
> until the related livepatch module is loaded and the livepatch
> ftrace callbacks applied.
> 
> 3. The naming is a nightmare.
> 
> 
> Ad 1. and 2.: It needs some "hacks" in the module loader. It requires
> calling modprobe from kernel code which some people hate.
> 
> Ad 3: Livepatch is a module. The per-object livepatch is set of related
> modules. The livepatch modules do livepatch vmlinux and "normal"
> modules. It is easy to get lost in the terms. Especially it hard
> to distinguish "livepatched modules" and "livepatch modules"
> in code (variable and function names) and comments.

+1 on naming is so hard for this. 

> 
> 
> I have never published the POC because it was not finished and it got
> less important after removing the most of the arch-specific code.
> I could put it somewhere when anyone is interested.
> 
> Anyway, I think that it is _not_ the way to go. IMHO, the split
> livepatch modules bring more problems than they solve.

Thanks for sharing these experiences! Let's hope option 2) or 3)
would fix the issue. 

Song

