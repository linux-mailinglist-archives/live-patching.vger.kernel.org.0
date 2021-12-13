Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7639B473898
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 00:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244211AbhLMXcg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 18:32:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37458 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242230AbhLMXcf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 18:32:35 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDMe050030634;
        Mon, 13 Dec 2021 15:32:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=J6lEB4BG4le7k6GfxJRX4d57F5d7n1skjGNCmBSG++8=;
 b=i3Ss+2KakuoJwsPgC1wdBW4r87OwuCqEuno+vuiqU4blIb+so7Ll0syJ6SFF6cZMrpLW
 JEUVCs3I2Pbkin2eKyEl49q042qW3GZvPZi91q5yPWzcFGhA9SlMg6tUpPqLntuQmE5S
 1hKAhp73n8sDZvRGY6Io+qr18SOQhoGYPCE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cx9rku2tw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Dec 2021 15:32:33 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 15:32:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPNc18xc8axhSH+BJIOYi2tAaoDPLl3huIPKus7pUjcd4y6b/f9qK2e3BWHehqhUbwpoQnB4YQPV7aVsDOFpp+NIrxOlPqXMfk2tWyeX7shnqLN4fp+MdBhdnkQpHa7JM/YvaGLJ10sfRcACpdDMR0oarzKVQ88wyxd2/1aVyN90HfTQXJXmiHIpjMrpORFr99MLiVJHovg7gNH4WUqWVc4BYGW8mmPMSzX8HbORc3VGImicNe+FBbGiedrbJTGN2PgHPxRsFafb+Lwfq94xpeF18SKZRcWzm4u9FREGGdZLNngjcVH40CKyF+yM3YXF16/m1IIQ8fyfJGJVSLN4lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6lEB4BG4le7k6GfxJRX4d57F5d7n1skjGNCmBSG++8=;
 b=m1ZRYXn1ppBpuz4Ls/TBcxXXnttzd/q4kUyBmRABP7GH1qGgTAaHtrFihJYLHAW4lVOuFCwI4cbHJFhamyUh2w3ic9Nb8YfbZU2+zA4qjSDOIiyK1k+bW446l7rNA9VbnSUhI/GU+BMSECMH8AnkeE/0xqL+dKQokzkOUO1SEy5NFI+4Lcv8tv8PGWSHZjkNPPwuklO36RH2/xpE75usq+T+vbPl1ZXiWoMK3dDWvi6qroE/XnI5Vxw21jinm1NLtqqchPef+K8mcbqFJMmTm7VXLgWZZnemrY2eaWmlOYmKcK35L/FWPIMFNY/LmYoUfyrYcX4m/9PFPAdkeWPboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5185.namprd15.prod.outlook.com (2603:10b6:806:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 23:32:26 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%6]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 23:32:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     David Vernet <void@manifault.com>
CC:     Josh Poimboeuf <jpoimboe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Thread-Topic: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Thread-Index: AQHX8FYl3jl3ooPws0ST1xMl/M/lM6ww2j4AgAAvAwCAAAlugA==
Date:   Mon, 13 Dec 2021 23:32:25 +0000
Message-ID: <C10BAA59-BBAA-4EF5-8819-72C9D65E85A9@fb.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <20211213201022.dhalhtc2bpey55gh@treble>
 <YbfQHjoUO5GTvImR@dev0025.ash9.facebook.com>
In-Reply-To: <YbfQHjoUO5GTvImR@dev0025.ash9.facebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dce28da-9f23-43b9-385d-08d9be90d238
x-ms-traffictypediagnostic: SA1PR15MB5185:EE_
x-microsoft-antispam-prvs: <SA1PR15MB518578003EA6357D76E5B351B3749@SA1PR15MB5185.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8643dAkDXADzRHhwUnRnOo/iNzpgmOQAJt/Dr/d4sg0z1iE7eQgitJUkkwdfdQWvZw1II4HxmUHKxPF9E+8x1H57W6LRzTkW5Pksqx1xyGXqDNhMYw6dTM3I+KCB13xEjExnhDbcC5gTy7ooTepmEXqy1nA3a8Oa86sKLO8xU3irnh1dvXLyIznmIAnOzAWF+fDdwLSSUVNs6QL5cRf3NBQGxzCGtckQ+b51U1SCooe719LOMXcjGivbU51WtinzRW5NetpLJ0ST9lgL5N8GAhWQlkYVDZE4xHT9ctnljmDRJ3fwC1mG/3wTOveS9+L1KbT2pkM1OcAn7wm0Jls2CB0kExLT0js/3vT7Ahd99lCXMW7V26KV84mESNsb5bPs+m1WNnZ5gXKMwWcMh+4GyhFTZ2Phkxi9csvJLxEHdc8inDZzDh5QPP03oug4jLfWDroc6DaSILo3yfxLEQqt84MFPP3DzLYHF6rMmGg1WNfbf88j0gxTbhZxpOX70accSYyvktP4IrsfHzrBGh7JqVopmYNLBzFy3rq+2kl2z+TvIcdK5YWIErVl0ocCrHrjmsAq+l9drmn1d650zGMLGj39dJBPmdgk1zYOuUNHmaXiSLJAau1KAiuJJZzegJG2T3NU0BofEdBSU5oGoMwY6uz1i5qfgcA6PERM7TeVwfEtn2VHHDwrBrA1Rgjjys9m5r9xN2CrOWJDCwbNhoL6/D5AT+pRSL1vyA8TPHamoxAZZDk8w+bOixhIfr5Aeed4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(508600001)(76116006)(91956017)(186003)(8936002)(5660300002)(6916009)(66556008)(66446008)(71200400001)(86362001)(64756008)(2616005)(6506007)(38100700002)(53546011)(83380400001)(2906002)(36756003)(122000001)(38070700005)(8676002)(6512007)(33656002)(54906003)(4326008)(7416002)(6486002)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YoHSbgDMXQxvHCmIkxGzw+jvbmcHDAEMOJM9JCg6r7GYj49DbhPYZSUNG/PU?=
 =?us-ascii?Q?1K+eO3/2PoQGOo8KBrkynrwxIjSvwVGhh/heZ5QDsZLFx1epQG+TMnfBZJTg?=
 =?us-ascii?Q?6v6cqZBZE5nVupArOZXUwbeF9SkVqKVHwegI4bqJO3R7ppifp9+v6GngyY+T?=
 =?us-ascii?Q?J/iks30FrIODFn5WwugbniiHwEpwBgibYSJOFkr266nsstYVsC4TkxxuFMV+?=
 =?us-ascii?Q?hzXPCowZKXR4NeYJivt8em7qh9COHPo0yHQdStgHH2Zjtfz+SvlRg0Gz6vDN?=
 =?us-ascii?Q?KNaqo1TgebKiFUDklrNPHpz/USr3dNzFQ5D0yfaj3VIKS6qaXUjBcSnh9ctq?=
 =?us-ascii?Q?0BGWtRxKGs1osDH2KJFTz3EiVC+MDUUsXxxtnjyFxtsL8yWKJQZvOk33ZrCT?=
 =?us-ascii?Q?S3vosOlrT3adbFKTIi8XA6MrX55b0FEKBVHLSs18ZQ5tP8NfwOuBgAcEkHk4?=
 =?us-ascii?Q?SpJ7NjrdtXwkfGfx091/dddRRoAEOleQRL6cwq3X7nBlg/4EEWdUb1ibtpSr?=
 =?us-ascii?Q?73gUUNbFHKdeWzBl/tPAMNE6shdMzESUyNDmVKp/2mC2jI0bFxjDJRPWndEl?=
 =?us-ascii?Q?yC0cLtona42bWjdatPUNUUbcQvQw4vRX85eZKnB9YK+UhFt6yxjdfm507TfO?=
 =?us-ascii?Q?CpH1rtNskPgFextNC1qV8zgIEv3Cb2mqcbUIS0MzK1DOIS9Bb4rDK08vGETF?=
 =?us-ascii?Q?yx4V4Ibx3StsZymlAa6QeTqMChUWspUGep88NENyAFLVXs5EfwQMrNbGK/io?=
 =?us-ascii?Q?pj6n2yyfJegSnRmK/AHBNmbU76XdsXJhdg0ErGv5NILffYJCCLf7Zz+vOH44?=
 =?us-ascii?Q?DKUmXdqwLmO3DBcgFFXLUjQX2gNS1P18CmIV0sJrgEOD1SkdmtoX9Txb/KUi?=
 =?us-ascii?Q?hmDsnnnCGN3p8z8cLnua8iiE2cjJ07UuOCTULQNT5qAtfc036AQgByQY7iWn?=
 =?us-ascii?Q?6yisa4x1a6951gqsLj5HjWbs0OASRNiWkt0KuBfMEEBU5BNPeQiVASuO2/Xd?=
 =?us-ascii?Q?k/z2uetyo6BGGBL6qqYOGzTKTyPKyzv3sINhlXgH/G78DF2vS5vFRLlehrZw?=
 =?us-ascii?Q?aUM4ERePuhzZY22oip1MHdHV1XxTxwJ8+O3qQ5jZOqB1YyNNIh6S1SwkPmnj?=
 =?us-ascii?Q?QHPC5Uy/3E/v6xFiY8sgifkpTEgu8vkiRjJp4/FFzmTs37k5fzPNTUi318F2?=
 =?us-ascii?Q?AuvEsCIeZGAqf9g8p7fPZLyGjJXZhpQ/swjlKy1VDOVHwb1WjGfc9lHjUFuH?=
 =?us-ascii?Q?j86C+89dtYCWHWpmxw38pDohOpJF/5mwuzzjpli/nZ+Q3TCY17Hrx5L7+Enp?=
 =?us-ascii?Q?8t9P44M110kTAW5kQdC7AUIHplVxR4l2mz6iYLCKSLwpFxfCm5uDtfsFjEeK?=
 =?us-ascii?Q?wFe0rXri72rtMvfEMAYJc4Lss3W3KCAYlzEN29l8aVJeixV3nK0CN6jRrabk?=
 =?us-ascii?Q?vhOvayEzsAFYaP9T4bdelVhEXBTmud8PHIz9oNFvB8/3fjUq910JuIDEgZER?=
 =?us-ascii?Q?JfKNZP7NzRSDA1i/ydWX8cVvajF3d/npVKJzRSPhVMIg9qf4wVmp9ByhR4HK?=
 =?us-ascii?Q?pagdHsyfPWEBEXQk2zwNRxDEi3nAW+I5gmnOptDfuoZFMNqH5/Ar1aWqZBKc?=
 =?us-ascii?Q?aLSJ3kfISaGxghzLzFZYEdlaHzzx50ZnCrMCVGj4AzGMRzLfAhd8UBM8zscS?=
 =?us-ascii?Q?mK1gQQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C0B17A98AEE7840B59ABA73E1606EB9@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dce28da-9f23-43b9-385d-08d9be90d238
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 23:32:25.9879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HETddyUEkKFD/m6S5L2zQce4gmkVVT1ltHSoR5bjyeEHma5Aeb2Tptd0hK6zgaEOk+WYga1ERFhOS/0ldbA5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5185
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: KnlASLiR8XX7Bru76pN2V-fFxXfQUHqF
X-Proofpoint-GUID: KnlASLiR8XX7Bru76pN2V-fFxXfQUHqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_14,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 clxscore=1011 suspectscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Dec 13, 2021, at 2:58 PM, David Vernet <void@manifault.com> wrote:
> 
> Josh Poimboeuf <jpoimboe@redhat.com> wrote on Mon [2021-Dec-13 12:10:22 -0800]:
>> The patch description needs a few tweaks.  In the kernel we don't use
>> Markdown for patch descriptions.
>> 
>> A function can be postfixed with a trailing pair of parentheses, like
>> klp_enable_patch().
>> 
>> Other symbols can be enclosed with single quotes, like 'struct
>> klp_object'.
>> 
>> I'd also recommend avoiding the excessive use of "we", in favor of more
>> imperative-type language.
>> 
>> See Documentation/process/submitting-patches.rst for more details.  It's
>> also a good idea to look at some kernel commit logs to get a general
>> idea of the kernel patch description style.
> 
> Understood, I'll take a read through and re-submit the patch to honor the
> norms for Linux kernel patches. My sincere apologies for the noise, and
> thank you for the positive and constructive suggestions.
> 
>> I don't think the fix will be quite that simple.  For example, if
>> klp_init_patch_early() fails, that means try_module_get() hasn't been
>> done, so klp_free_patch_finish() will wrongly do a module_put().
> 
> Ugh, good point and thank you for catching that. Another problem with the
> current patch is that we'll call kobject_put() on the patch even if we
> never call kobject_init on the patch due to patch->objs being NULL.
> 
> Perhaps we should pull try_module_get() and the NULL check for patch->objs
> out of klp_init_patch_early()? It feels a bit more intuitive to me if
> klp_init_patch_early() were only be responsible for initializing kobjects
> for the patch and its objects / funcs anyways.

Pulling those logic out of klp_init_patch_early() makes sense to me. 
Alternatively, we may also have a cleanup section in klp_init_patch_early(), 
like below. I am not sure which way will be cleaner. 

Thanks,
Song



diff --git i/kernel/livepatch/core.c w/kernel/livepatch/core.c
index 335d988bd811..20b959c82204 100644
--- i/kernel/livepatch/core.c
+++ w/kernel/livepatch/core.c
@@ -864,7 +864,7 @@ static void klp_init_object_early(struct klp_patch *patch,

 static int klp_init_patch_early(struct klp_patch *patch)
 {
-       struct klp_object *obj;
+       struct klp_object *obj, *obj2;
        struct klp_func *func;

        if (!patch->objs)
@@ -880,7 +880,7 @@ static int klp_init_patch_early(struct klp_patch *patch)

        klp_for_each_object_static(patch, obj) {
                if (!obj->funcs)
-                       return -EINVAL;
+                       goto cleanup;

                klp_init_object_early(patch, obj);

@@ -890,9 +890,15 @@ static int klp_init_patch_early(struct klp_patch *patch)
        }

        if (!try_module_get(patch->mod))
-               return -ENODEV;
+               goto cleanup;

        return 0;
+cleanup:
+       klp_for_each_func_static(patch, obj2) {
+               if (obj2 == obj)
+                       break;  // done
+               /* do clean up */
+       }
 }

 static int klp_init_patch(struct klp_patch *patch)
