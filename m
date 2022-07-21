Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8465557D726
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 00:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiGUW7f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jul 2022 18:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGUW7e (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jul 2022 18:59:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A718E1CB;
        Thu, 21 Jul 2022 15:59:33 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LJkjZb009435;
        Thu, 21 Jul 2022 15:59:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=FZqtuzS0NK3paWbr17RfQsT/qRAuwdnRXdTcLi5fiNE=;
 b=N2tuUvkEuI9OcxHZwh7mICMQJp4wjBbv5M7OfmxRwVxDEzuNEYsYE4vG4azNtm4gX457
 toD8wfcOySWd63nLaTxfyeqjfTgPVRt06j70hcX9NdaKK/dFcOyJlM63MORoR3uOmk7/
 gyuCoMZY8DeS44RvxQzxmiDbVzvyhBcUb6U= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hej1vu2sf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 15:59:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJG7soFyTAcJSmtz1dR0ChX2y6s5CJVoz9wVlNPTgiXQ6Guvw6X/q4Zeuk49zX5Kg5LP8uxc+yLsYF977dmS6BuVGb5afY+z2GamMoZIUL+VdD3rfOuy0gijynxliUxMx836SFQGzr0Cu5eCbtus/k20xLLxMVjCaA4oLpzW5BB790fBwArUXf0ZCzPQafCmPfA+1qC5MIbCos6+8IB++RMwm8ofiZlUYGs4mBNIf4CoUbnAgqsIivruvpfmPk2GwPAyDnecyfzAgXx9989UhyXzWuHNRjZXWAE68y1IhsaPO5usl6CpWHbWs4jT/teD5HZl30ELCMV5qrhSNAihAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZqtuzS0NK3paWbr17RfQsT/qRAuwdnRXdTcLi5fiNE=;
 b=VxYqyNhpAM5zFe1lDKN1ELVSCTecqaKTkDyNHkYEoDILwiwVu/PrN791S9FuFSdhK4LxfGsaixi0IhCIXBkp8/qwhWjTqFf1ARHKArwl1r4vxijphNyWT/pgGhWssiqF8RY4awXBhzBgKmolQPClrIar0YEj4Fa2IHo/H+DsW0q9dCYO9SSDaylNFlsnzvfQSKGB7I2qJ6wSTy/6xg85zJT8nl/xr/26ezFldVOPIIE4HIi90QtGlzu67IbHqtDrS3n76O5kEouXOljaYVWlYX4Z0y9ncoEu7nl/wlnC/l/4ZDW5NLqWwZIbM5VRqhOPlVOMzZq6+J8VfWuYV80k8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CY4PR15MB1782.namprd15.prod.outlook.com (2603:10b6:910:23::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 22:59:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:59:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 bpf-next 0/4] ftrace: host klp and bpf trampoline
 together
Thread-Topic: [PATCH v5 bpf-next 0/4] ftrace: host klp and bpf trampoline
 together
Thread-Index: AQHYm86zhN8thRtC40unIKKXXAqaq62Jc3CA
Date:   Thu, 21 Jul 2022 22:59:30 +0000
Message-ID: <257B5D9A-7A52-4396-82F5-9895782952BC@fb.com>
References: <20220720002126.803253-1-song@kernel.org>
In-Reply-To: <20220720002126.803253-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a84ce8f-4dfb-4941-c31d-08da6b6cab76
x-ms-traffictypediagnostic: CY4PR15MB1782:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3Rw/0mYhKm33eqUzMB4T4s+bp+RrkzqdscrdqGq+nAdgMEz2Fpxs9wtbRwN8B+GJl3EuJW7u/JXbY4FwZ5O3U63sgT7V3WiSb/eUpZ20PBAxcXQptTSLtsaxGRsj2w1wLYZrbT96BOe0dCREIwxVAyx0szCU2bpSB5PJr5b/BsBqn0G0PMmbmVXu2iJuIIO1AVmAvfutcu6NOf+gm+Re+pk3D60hZcdATPCfSTn0Lv6HBVBoyMKUtDq0aej8wp3tOCM68656ahu6bu2RO/M7qDjO3eDehduhz/6peAldgxdgo+JKbXb/bS9eEJL8uB5WIyp3Ayrg8GONfSmcOURXHLWgGHmWx3t0OL51GV00thTAGCKicfcd53itaoyS7petL5HmCJqOa/B7UGxcXITOe6LUd9rjHv6jX+nK/4UPl5EAoWJiDXjSB8jzkNrlv5VJcs8GlP5HKAxd9EKUNwwnmYLqCesKkZidmS3VTItPmR4NBfRY/PkXltGm7WSok4D1S9xaufXMOCqaZmUFZDUOYa5MgkZbHbaP00QMxJi1BIafP261Ba9mAWvHhJMFBrCDnMNZcHSnr8SdLwYB0FhwjyqxdHvOKdNtsJi2yy8+nSaqp5UtTqrDARtVGMAZLX6Fe0N5ncmGU7oRstv10itMNR2j7KX3XOy/GSuAAtJUloj2EEKcG/7goUt+BM1FymxY4baFCFEQFnNCbhe8xJpNNij1Ez3zXrR1oS4ICj4Bo4Xt99vM0Vrnd7mTPm9EEy/9+3XzkBzDXyW97+46Xmfk/hJzzD9HppT1u4gW6Lr1DNsXbm+vBDniaz3Rje1uEEMFqH1MEhlbOYeuoszZ5cFRm4dc+Lio50IMUBi3TydV8RTGa0E3+Zet5ccxtYhgeBV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(6506007)(2906002)(53546011)(5660300002)(8936002)(76116006)(36756003)(6512007)(478600001)(122000001)(6486002)(71200400001)(966005)(41300700001)(2616005)(186003)(38100700002)(38070700005)(8676002)(86362001)(316002)(4326008)(6916009)(66446008)(66946007)(91956017)(54906003)(66556008)(66476007)(33656002)(64756008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sBwee8LAwRtCIql4Pz2E7EvH+Y29QzP2P0fc+EcX/VheZ2IqTckla7R3NZDH?=
 =?us-ascii?Q?0hbyYFF/j5D8zV7C5pPK9yxPU2Lx36bcYqXLGulyExscxK3zpnYXD5qc1E5S?=
 =?us-ascii?Q?T8196O2LVzmliioCTb6Ev4wqdp8qtWkOk9o4m9dJNWaqRPWolJFekcsCLix3?=
 =?us-ascii?Q?TcBaDkQVM0HRS345dSIRegbfCsaFH2IjwTsg0Hxkezv6a0vy7TxFwbV0ZNUx?=
 =?us-ascii?Q?dsTSeXzABW/Rf5T2wvZj6umt487h/rbZPiKKKb4ei/b9uVr0vXEkVgfY3RhK?=
 =?us-ascii?Q?aY1KSjh5uIJfpz+frLU0Btvd/yfUI3rmvX6wBsNODlwxBacDK9FckPBEYR+k?=
 =?us-ascii?Q?ahcwu/56t2Mbb7/riHTVpzpO2/y+HQ7o9fzA1NTnbGEXh19PBBv+PYfLqy8F?=
 =?us-ascii?Q?YoUTvSkqVgjAxTURCx9Kdf12XVUgO3PNAatkxKIH9ol+sGfoOQ3Ao/gYPlhL?=
 =?us-ascii?Q?1qxJBJb1i9MjKztb+p/+vNvzX1pFSuApsBjfD7BnuFpiv5SbAe4Wnf+t/ON4?=
 =?us-ascii?Q?AYVT6C3du+1wiJs4Grun+hfr+fdrfdhQwrRGHNrZldo05VhT16INQRJVYzcF?=
 =?us-ascii?Q?c/a4KR1cbWdfmkoK+7LO0JWknuj+35iKDgW/3Dwn4vnIyUAIThqa4EM4pcaH?=
 =?us-ascii?Q?dMIxEy7X0Tz6GrYncQ4zZvkMjoZ+q05ikaEFF76WqdsfUhWimTYOvfZndd/S?=
 =?us-ascii?Q?IVP6qYg+gDdVaBi3YocedTUHhaSkKNuhUN3noPGmbkE0YhSHMSJBm8Fl+gT9?=
 =?us-ascii?Q?YNsfo8i6JTmAt6oZ9+s68AwZMETY5mqcIMkKWCcVcjwYlXRJ9FX0u3Cm9qTV?=
 =?us-ascii?Q?87MJIINXRU1vm9/o6kGQqW4MynJ+7s89WAbIrJsycz69xDN6pfRAsIbIiSE/?=
 =?us-ascii?Q?JtRn3zh9OFcsXIi2hX1OR5tyhUHhmXzGz8mAQUk6MxnDalK7DxU6yElf8wyv?=
 =?us-ascii?Q?6grYk6jLF5tY3l5ayiPTBX+vsDaB7mey0o2iyyTc5ogYlVGcIaRUTRMDJ8lF?=
 =?us-ascii?Q?xF0v2ANcCRlP9fFOAwObW5OwPqKBdX+cc7YFYDaANFqaPXOItDIemSYwO40L?=
 =?us-ascii?Q?wqgAzUKgOgrh5hpqdquu2WVyMlpWR6du3Dn/LutAbktlR1QBrYP0qdcZGKZG?=
 =?us-ascii?Q?SaKQFyG16arDogXoAVUvj3PrDCrkXEHrGOdOoQyGlaFkLmadujR1cvrmSHXR?=
 =?us-ascii?Q?z5yF8UO56zirmoZi1r2lV8EunjiCvf00cWUWHeNVVyBHhbwgAQfc6hgurInb?=
 =?us-ascii?Q?/QKXi3XY8KloLalygipNYG++WSJ7g7xB/Rq3GO7onVOBi1ac1+jCieZRrahk?=
 =?us-ascii?Q?ZgE98qU3tbJZEDhubna1JzEbyZhDyiOGzwd4JygbdJhzoiCOLhdcoO3cThWs?=
 =?us-ascii?Q?9PEIriTWk2zJ3KlT8gbQoKm0+kGFHbjFk3PME+VCtUMnabYNKZKibsvlMsKv?=
 =?us-ascii?Q?30yUI015KQL8drFyjCg2QdOy59wDntfOWOmVyTtHTMQcI3NRfIhZWwhkBuac?=
 =?us-ascii?Q?ZSfZlKguz1UBD7nmFvq3zIAFFlDinPIK/mZDem4Uxu5GghqTWrS55mjgsvy5?=
 =?us-ascii?Q?UDWVYDeEEt3LiR2Q8K5zDUIEchBR8o9bOkRZF3H/tefQXk5cEmOWnBRsky/R?=
 =?us-ascii?Q?KQx5557dwrI9T/mUVYTx/7I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C155F1632455074B9455E9212275F996@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a84ce8f-4dfb-4941-c31d-08da6b6cab76
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 22:59:30.3517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rwkSUSw0DWuRP7hCNHbJg7mFTPCuU3HFs+M0rVNOehmOliPYvq4rvCzWullg2kyVcRLQmaruofSi977iro/JYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1782
X-Proofpoint-GUID: BO-e5jeSJhcnAVYL7I4VkCNKs9-njhpr
X-Proofpoint-ORIG-GUID: BO-e5jeSJhcnAVYL7I4VkCNKs9-njhpr
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Steven, 

> On Jul 19, 2022, at 5:21 PM, Song Liu <song@kernel.org> wrote:
> 
> Changes v4 => v5:
> 1. Cleanup direct_mutex handling in register_ftrace_function.
>   (Steven Rostedt, Petr Mladek).
> 2. Various smallish fixes. (Steven Rostedt, Petr Mladek).
> 
> Changes v3 => v4:
> 1. Fix build errors for different config. (kernel test robot)
> 
> Changes v2 => v3:
> 1. Major rewrite after discussions with Steven Rostedt. [1]
> 2. Remove SHARE_IPMODIFY flag from ftrace code. Instead use the callback
>   function to communicate this information. (Steven)
> 3. Add cleanup_direct_functions_after_ipmodify() to clear SHARE_IPMODIFY
>   on the DIRECT ops when the IPMODIFY ops is removed.
> 
> Changes v1 => v2:
> 1. Fix build errors for different config. (kernel test robot)
> 
> Kernel Live Patch (livepatch, or klp) and bpf trampoline are important
> features for modern systems. This set allows the two to work on the same
> kernel function as the same time.
> 
> live patch uses ftrace with IPMODIFY, while bpf trampoline use direct
> ftrace. Existing policy does not allow the two to attach to the same kernel
> function. This is changed by fine tuning ftrace IPMODIFY policy, and allows
> one IPMODIFY ftrace_ops and one DIRECT ftrace_ops on the same kernel
> function at the same time. Please see patch 2 and 4 for more details.
> 
> Note that, one of the constraint here is to let bpf trampoline use direct
> call when it is not working on the same function as live patch. This is
> achieved by allowing ftrace code to ask bpf trampoline to make changes.
> 
> [1] https://lore.kernel.org/all/20220602193706.2607681-2-song@kernel.org/

How does this version look to you? 

Thanks,
Song


