Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE19733787
	for <lists+live-patching@lfdr.de>; Fri, 16 Jun 2023 19:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFPRiL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Jun 2023 13:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFPRiK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Jun 2023 13:38:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE7D2943
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 10:38:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GGdoXK028701
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 10:38:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=QX1oDJ6kzUGOl4of4u6+SFo7RSjRfwxj1bbcEHBzRI4=;
 b=TDuLJmEwCRK94QKjKXos35leQ+V1Kv5vl3DwHovg6m/O4xpqmSleAsalSF0sMH0YqIi/
 Rk0GvvzLjFhtScDww5JCmYhtyPP7Y2YgIjc3fFaY83ebgQemBwvgx28cOW/DL3rSg4lF
 VAIwDWEsphHLN4iIy3HcE0MEA22yrc+tMF86BrhGkvnuLj4fTuMz9OwEZ3BBLvjeH6Pl
 L5gmtIHMoCVVGv+n9OsMb2Y7wD+Mhsr8baHeqmZ+RIFqS27zTUvFkSGmXdYCgin60knL
 tRfqOQMODitqYvaMnZefT+1Zw55eeGbwhG4Z6x0PV3RS4IjRiePDJ/AMgiVRhoicYqBF Jw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r8uf08gxc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 10:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1nudwbIueq00taSEol5zOrSyc1bhjdPTnqZzeWDZLHEqVdm4hMapxtwro6xENKMggvWaCT8XOoUTD5Q09R+aikgUBKdjvy1SRxmzNqnnrIQP3uYlGjI4E78dvC8x4t5qFs74tsG1Fw7QU6Y5tHO7slrc9ae6R5XZMl3y6IP525MtAWyvJsRIb3I4KFfywQ1ZnzMwgksyS4SCma/+EQfu8vCP+goSCzrVFLz93GnVk5lAFRI80Bv11PpIIJa/lu4uZLmAYV2Bw4+PeIRalLJQYOU9WPHGAzD9DBXHqJUDrb3e78gENh3ZN8QyMqWFI3fzT1pbow4jlACz617n4QKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QX1oDJ6kzUGOl4of4u6+SFo7RSjRfwxj1bbcEHBzRI4=;
 b=LPiUIvM1T3eyHXt3KdQRZ1wV3OPEYPzCEca/uVRqsWuQvgR7EGAubYaWzLBgmfGmsECP6Rdt4/yLWtwSttMdGI9TSVUGayBwzXCQi/3k7rCC9rq91zyhluqqLUhCoP3Deh4Iufm7tr1vzPwGL2o4Z11wIbjS6DYBCKgNjS0/vH8ifIKDqYVbpkXGg0GEs7Xt8p243YUywdabzwvYNxmqbZdmIlwinv9SGSsTUQ2nesPBaN009FN659A2rsu6inIPSoB3c/j1NnRA5amPr6s4eV5OM70Uu+ebL5cvnf/UZfzKLRA/pBH44qN2Hl5vOUNDx+Oo5GZYl3IUlMGyNHAOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB4524.namprd15.prod.outlook.com (2603:10b6:303:109::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.30; Fri, 16 Jun
 2023 17:37:45 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 17:37:45 +0000
From:   Song Liu <songliubraving@meta.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Thread-Topic: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Thread-Index: AQHZn6r1VuNYFv7wzUinZRrB36Nwc6+NK0aAgACH3YA=
Date:   Fri, 16 Jun 2023 17:37:45 +0000
Message-ID: <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
In-Reply-To: <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW4PR15MB4524:EE_
x-ms-office365-filtering-correlation-id: a9b6e579-de91-4b60-3237-08db6e906519
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pj/khAmxGTTvQ+S9Ap+F5s6WoWFUxqJLcns0iTW91RRMPoAs+zht+0w/awAcRV+1+FMM8OnC5q0RfeYf7TURZL0yHvDvSUfvtLF3BtRfOwkjgnlmc8uYZ6EMHFvkTOnw6xKnAM75oJjU+JpolUPIS5wOvVyxlsalaHbmz5QZQI9ivvcdmxrp0ONlACAvIj4rzuFXujRV2KniKJoeGq1fMZ8iphZfb6aqMtXw9IVzM/T+GaxkQmhlioZLe7EFTV9xstaiTKHENEliIFT5RpingX1MTWZqB8nNcUxvpIdxItQ7oNezvW9tKTrpFoGq3QJUK6SQJqpT4RSpz/SKDk+d+NL9sEm3+KEm5xQlAnYw8ZqlaRl7oSxDjEUnNs3WT9zkpenFkzfc4yIRuAGRCnNkq1ON6g77jBAR+pVV+gvg3d52Scs54xywY/xfq25giUSmIyXEjYNI65q6QxeDMlitGWzo3KjH6WwKmQFmKz9P0V1dtN7MPEvb+J0UCGw6yIzyvpCYc+Wa5a9TMQtx+5klBe89+9Da6ThbYa0tsjPmOr3P7Ln4euXYBN0wTgqZVjA12CVBSQlAeUoc0JZ4vLZAw5ihahOTw2AKcIukmrQND7PzcWpCV2aOle2zPJT9aBwxlFZ5+US2JhkHiDymryfCEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199021)(83380400001)(2906002)(38070700005)(38100700002)(122000001)(36756003)(8936002)(8676002)(86362001)(54906003)(5660300002)(91956017)(41300700001)(71200400001)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(6916009)(76116006)(6486002)(316002)(186003)(33656002)(478600001)(9686003)(53546011)(6506007)(6512007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xxuBfHT0WWsZCKDzzotWhv2NZVroaa9avfIFS3qEcSr6Ppzpoj1ebF2vVl39?=
 =?us-ascii?Q?b8C6CmvUfXp5iavsTElASwKc7Ae2dpNfzsvrP/PYwWT00Irq+mJ88jr5BThH?=
 =?us-ascii?Q?ogWeQmjD823CVsMn55WKWjw/ym+7S32S5CnURzc7ommNl+Tk+mrWzDc8No1E?=
 =?us-ascii?Q?1at3nrjIjNOO8+lubxDjAQJo2o/gzrLubMjbVsthPGRRwzCdi73CVCqh7J6E?=
 =?us-ascii?Q?U3Eoim13sLIBn6qxHQHq+ydmlXZ+koPy7SsluhJrWvHF3gZ+yFy/XUYwVzH+?=
 =?us-ascii?Q?nkn1P/IVpxb0yXVTjlit83dkvlclyTGEWbyyFtdlQfKoSI4CgSmHGZwxbAB0?=
 =?us-ascii?Q?rBc9i3hCIlc7s3Ypwc51688gEJ2Nl627klD9rnPrYtBFn7IJzic5gPra3lqp?=
 =?us-ascii?Q?KXfurACCfzDXUg/tTnpVRGkPvR4hmY3o00iGZAQL8miuJB8fVZsHk67rc9x8?=
 =?us-ascii?Q?WQVqGQGsXA9+v58qrdkXab7koAatZwE7GQX3W/EAEXZxC2DP/8H/5k0SKyYC?=
 =?us-ascii?Q?8IUdoeIPMzbe36p+/fNtMgakvrZEKNEaUZI++9KlfIneWkSNl+EHNPMokems?=
 =?us-ascii?Q?69No6KRZAZqrdIhSD6CmJV926yPj6bUt2+MtwxoeoAWh9wfDZlGazjg0ptH2?=
 =?us-ascii?Q?CkZUV8+3F0mrk2jFqEaCY4ZmSe821dnI8yADvBaHXApTT9B8o1u3nPx5wllo?=
 =?us-ascii?Q?qD8UjrpJjiiHl/fPUrN9HFpLTUE2ysY2Z29R+a9KP4jS40tcBQ9ImPJK6c1W?=
 =?us-ascii?Q?6kClg8q7jvwFLrEHMvsAkzUGquRDpD8Lu1wugsi8S7Xco5q1ib+a3QqsouS5?=
 =?us-ascii?Q?2p0hqDhhRzdF+oniL5afl9bbPXiMh1TftFo6JSrMYHRaSrHh68d/lW8hnqud?=
 =?us-ascii?Q?P25Ly0I8FBh3/ofZ2s0E0TEPZKepQpuXsK3OKzw2A4KWvMT54Twliz8HbcAu?=
 =?us-ascii?Q?7B+NNQiVyM9Zc6wJH2jLX+uL/FXDrM9yQAYnDxv9BSH1AbJMD5n+jEU8nK4o?=
 =?us-ascii?Q?9JRHTv+DjON0tACIjBMq4ZKOvDTPmjmjPdnfwcF5W49fUXQVcO1CbvRc5Wlu?=
 =?us-ascii?Q?CfyyyQK0vOzwykPVuf+fh4RTF1obfCSwVko9GqVWZn1cYqQlbJ24Tn3V4rQn?=
 =?us-ascii?Q?klwsgLlb97rtSzF3YQgXikZyevnTy2mLk6cHejqq9ePsYK9HSX5ohFaLndSL?=
 =?us-ascii?Q?OyH29aMMDt1mM58b2dAIZRzYsbYFzShZ+pXOKUEYZmABvAWUHsKFFIELKrih?=
 =?us-ascii?Q?HCb49ECFpa4lHTGBTTe5fv1g7+YQjT3R9zEx8S44U3kxkKWmmCTpaqgYs/MJ?=
 =?us-ascii?Q?6phgb6xnbiOYURiCYjMX4HWbNrNfx+JFkSguLi4fFOMwvj/4b9nWHiozCUIv?=
 =?us-ascii?Q?NpiQGOfeETGQji0OYP6J1GcH/lB1a/3l+qUeJwOfZWqCN9TXK5DqZhtuUtb4?=
 =?us-ascii?Q?t6rc6xsNu9ANfx+M+/M37bgdsDWbMxFoy3U1RJ+pYMcdW0T6Mi+3MpIZ2Qi0?=
 =?us-ascii?Q?7szrVpGlfr/4B5EqjX4DnjI3eCPNhmfMLIZUS2ESk92QeWuClSipZKpKLcy4?=
 =?us-ascii?Q?kZ5rmJmr6bRIA1t/rM/gtpIAyyYm06h0PltimcR/RyK+60TsA2SbIGnHvGix?=
 =?us-ascii?Q?1G/A/DpcBbccf+GI6cQIPGk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2913C0AD0EF14408A003E18EDB3FF5F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b6e579-de91-4b60-3237-08db6e906519
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 17:37:45.3077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ek6tjTKKU3W/4q4NqZaABL3VmvFU9TFtJVgY5GPaqGxLTmRCmhxbkFlKPLDyUqs0gZvdRAO3RY/YZc8/YL1wTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4524
X-Proofpoint-ORIG-GUID: 53zrarO0Ys0V_-SDHW8btsbbJSxeG5SG
X-Proofpoint-GUID: 53zrarO0Ys0V_-SDHW8btsbbJSxeG5SG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_12,2023-06-16_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jun 16, 2023, at 2:31 AM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
> 
> 
> 
> On 2023/6/16 1:00, Song Liu wrote:
>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
>> suffixes during comparison. This is problematic for livepatch, as
>> kallsyms_on_each_match_symbol may find multiple matches for the same
>> symbol, and fail with:
>> 
>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
>> 
>> Make kallsyms_on_each_match_symbol() to match symbols exactly. Since
>> livepatch is the only user of kallsyms_on_each_match_symbol(), this
>> change is safe.
>> 
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>> kernel/kallsyms.c | 17 +++++++++--------
>> 1 file changed, 9 insertions(+), 8 deletions(-)
>> 
>> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
>> index 77747391f49b..2ab459b43084 100644
>> --- a/kernel/kallsyms.c
>> +++ b/kernel/kallsyms.c
>> @@ -187,7 +187,7 @@ static bool cleanup_symbol_name(char *s)
>> return false;
>> }
>> 
>> -static int compare_symbol_name(const char *name, char *namebuf)
>> +static int compare_symbol_name(const char *name, char *namebuf, bool match_exactly)
>> {
>> int ret;
>> 
>> @@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
>> if (!ret)
>> return ret;
>> 
>> - if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
>> + if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> 
> This may affect the lookup of static functions.

I am not following why would this be a problem. Could you give an 
example of it?

Thanks,
Song

