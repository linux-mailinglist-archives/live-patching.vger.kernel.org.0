Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8F8577A8D
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 07:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiGRFq5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 01:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiGRFql (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 01:46:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0B1583C;
        Sun, 17 Jul 2022 22:46:34 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26HMNfFv024767;
        Sun, 17 Jul 2022 22:46:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=p87VWD2qpyVopjDxb3a98JXIUWGE/EwU745DVgZzXeg=;
 b=ERDUjB+jB9cTQpB9vh6VYRxyyI4ZVG24v0XB+i4e8CeQcNEVdrJzkF4R2tLI5Wfku5zc
 9Fh6vQhjBOUZHbUW1Hrbk9/YfcW0PMDMRLQ6zUEgU1aLMMwQQlBUx1yrQV5QtjoQOQo1
 9rwRvys22HN3wVQVYFaDF78lmCoIV7oFeAM= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbrnqf27c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 17 Jul 2022 22:46:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R78nKfZsA9zlLdsM8S4+ojvW0s/l0KBarQJ+XMsy/UGTXNC6PbXvXpmBCXt1hThk/hRyY0tvXEkj0HFCA3puZhCewcwBjUPnh1NG4+3xldZtSSbW7zVmroLJjrSXkunoGua94NkCNNd0yh6rDJ+XzZd5wL+v+y1M80lygu7uDWzCIsVhp0sYVB/hrcw2rcNDoN1az/5HK9V1PQNp3+dZEh4NBF7rHgpQg83kws3/lzYb0DIvyxZ1mZkE34yavUdw9ctPialUNGWiCYCpFlXg3O07flqDcLmR6B1oMV3ylbegUn69igW10L8sSFWgdI7yb/ykQMWFMZcA3N+I3WKelg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZugduHJSIi9qmxSDGZRr3Pva5eyjpNY4EBYQ8sRcJXw=;
 b=bTKwDoruL6RmHySaXOhZNvgOE0hx3aH7B9hfVH+UkXVcVcPAnc3t3y7AA/XZpysK/KMl2F8XAbBg68nGttfwpPNICGez9BtBeuE3sK5rcjYitZ3Whq+FGIFQAflKF/SlHbnwV2zP5UrpHRSghcM9MYj+lDE6hVaNI4J2uYCiT6bVyL3E6qoMuAP/OI1Tg/D9EAhZLcPLfaLr2ha3EnZRQ9RqOLPS4QRoFeyKh1D/eH1/5Mq5wuPx8m3KP8hNGyl8wRvPF3caT6a1I9VHp+XXJr934PkUqdzy1bBC/W3hj7UZn50ib+E5P2dCRKzu98Das7qkoCsb5g0bK9jUQJQVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BL0PR1501MB2051.namprd15.prod.outlook.com (2603:10b6:207:32::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 05:46:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 05:46:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     kernel test robot <lkp@intel.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH v3 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Topic: [PATCH v3 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Thread-Index: AQHYmjtcwdB1Yk/E8EGz1+0tylNQ8a2DesKAgAAkO4A=
Date:   Mon, 18 Jul 2022 05:46:30 +0000
Message-ID: <4A8A2B45-FD48-4085-9526-2C0031342299@fb.com>
References: <20220718001405.2236811-3-song@kernel.org>
 <202207181140.tqIgD0Jp-lkp@intel.com>
In-Reply-To: <202207181140.tqIgD0Jp-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f909b877-0c11-4cfa-e640-08da6880dd18
x-ms-traffictypediagnostic: BL0PR1501MB2051:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KK/zSO2nn/XEdoOjMkiqpaO36fCq+ZZ4Nuh1RDnU/auL4bkBa2Df8b2bT3CIpHN1ga6oKsY1WElXiXSX4dlvpYaA0T1mjvS4JTI+U4Z+LzwR0avbfERIMOEu0KV6tX522b6huva2av1FQsSmOJnRT2Q3GNpZoBETt1nnUwIJeXWL6hP1n3pE1xGRuRyIYUrwEEuKC7uPkOqY2dOGan7A5sPiKkZUqw1kalnipULq7kmB6xxYDBkn/bzTKzUHZq0f9j6EsUoOX7aURFsypRKEpmNNZ4NZ5oM2Znq/jumu8JaG2svlRLniWYUt0dcJai8iqiS/Iq4WD9dB2r9diy0esJA62SxjA0DppVdmY7hIfqJveTWqY9OdTy0rrZu7kqvKtgkLroJx5vamhVPq/g3K7NYBLDaWzRa/I8PLb0c4xhf09/1/VOuoDserH8CPONP75+QgnA+dRGBWaLTF9j/mqQyNg/17hPHcdmHzqLmR98r5Rxdpc9tQDcuDyNMCdgMBgqKcgwhcctY3dJXlO741QeXBtwV+Jb6MbKjK92TtiIXco/rLe3i0zFrlMFCYHcP3Aw3SHAzHS0aRSdrNS3Y9MHxMWKAmgzQPURCszqfes2oMGsFVT5us1OLtciW2jG1hXvecntP4ki9rX3p9gXMVHoPyS8hfY5fT5Tod4284LbCp6cc0eT6TZrWaUO9z4RC6FkDAppcdf/7Pk/JEjSttfKdLcVVPnk46mWJHnVsatbosO+lrgI06AiGyLpI0Qml9ImV0pPwaVBI/7X1k0CUwR/tZd7zeCxCGsSO8YyuPhtd1SvioacG0jGNmeWkluXFe+/IBf8riOQ5QWX29UHEiXmpN2r6oFFZxJ/J/UqmpLclRacYN8dvmW5yLgV4Eoo5W0bi/uyB47EoSGwmP5ndLc50ch1ZxEKryyyPZaIy+TWM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(316002)(91956017)(38100700002)(8936002)(86362001)(76116006)(66946007)(66556008)(66446008)(8676002)(4326008)(6506007)(83380400001)(53546011)(7416002)(38070700005)(5660300002)(54906003)(2616005)(186003)(6512007)(6916009)(122000001)(966005)(478600001)(2906002)(71200400001)(36756003)(33656002)(6486002)(66476007)(64756008)(41300700001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZMN7Sn7aaW3ESmrJRLRvGXJWhWkprnQxOa7ZgPnaOI3jexThIceFSoA61LT7?=
 =?us-ascii?Q?Apoo6PJFo3yr5kFbivBxJqmMxgMg1Ktzl+IM0Pn6pdZmbAPXcYGcLuu+MTNe?=
 =?us-ascii?Q?qkNk4kvErchDAafUWOaT5poQEenhHewm7FZo+91Zu7VeK3MjKNDxe/VMMIn0?=
 =?us-ascii?Q?h5UBh1xTk2SkWs6ogybY+DEEgD7VpubT+1N5jTaPEdAtwAVakIITBJt92+FP?=
 =?us-ascii?Q?IwxuBStn9baRxB1Q4yEKkmDmf+7c3W0QmwklQsrLWiogUKFR7UtET+LDfs4n?=
 =?us-ascii?Q?JjZpLtaNrtzKm+NxRue6aVPbhQ3GWvVYcW5fsEKdVOr/HHm6dPeSSlNQK/Pl?=
 =?us-ascii?Q?KzgO4Y1vR2PTDumqjDdAcOjxv2xAaoDJV1aYbdzZu1G2kqKN8ud1kNbgzliO?=
 =?us-ascii?Q?liQB0hjmNvfCH2mY0+b32U1TpTb15LHBrLT2/Ys2WnKc0bmGA1ctIWaunk3X?=
 =?us-ascii?Q?DDr1znESHfeTTz71+T2QoXlIJBieLcwN+8rBgCnoFSHbo/wlqXVG1HTHUhd5?=
 =?us-ascii?Q?yVliCL+Eg6vCNYQuOfzu65c1mXPmwvylnNAotFa07wKqCKDGkhn7NITi/1I0?=
 =?us-ascii?Q?R0oif79tTOx/9KXXqDdAP/naIVuqls/W/CzJpoCkeM06k0gSTIZx3DS6tlPv?=
 =?us-ascii?Q?asbSTyO13OZWaiM41IAQeHzZCGAmAIQ+/ahF1Jc8IPfZrrNRUbbwbUh8N/ks?=
 =?us-ascii?Q?zkZTwZSVyXoYFkfkYkv+8LRXqePCAN8guEgdHYpzCCa+Xj07QQ7ZDjVD0WNB?=
 =?us-ascii?Q?QcrXw6NLqRCpdim8Tic04DTnWgPZHnWUvNkJBWiLCYWeQbDub5PbP9LJETtd?=
 =?us-ascii?Q?y1lrsX6rHGbKh65hs6Q4A5dEjvLJ3RH4Q7sJgOW4vtrs6vfbRa1fg/9WD+Y3?=
 =?us-ascii?Q?B9AHp0KcOovpl9ZK7GPpCOUu9d5JWmRmFoqPPQFBNRWVn25U6OYEEciGE6Zv?=
 =?us-ascii?Q?TbN1V03SjAInGruxHtm8UKUMUpZBxveAPSXGFugQuitFwdfQ2ll0mtWq2ysz?=
 =?us-ascii?Q?ydV9uMOEpD2xOz64zuxMN0eSdnNXTtbebk91XXh0f1T/slU/H1fNdHigyEp2?=
 =?us-ascii?Q?SsHF2NaFPIOmQWa9riNPa9Hj9qHfpttpeVWA7rVtccp3XgOIx09rb+mm9IGo?=
 =?us-ascii?Q?l9Nnq3iEPDKkHs+6ND2KAb1cQVNwsj+giq4JLBoqxkDFJ2h8wuQJwcpSRccT?=
 =?us-ascii?Q?0/vggpbRt/XwvwQhIi8Giq9HF0xae+XR7c6bUDayRve2fhwagjDw4uVD8G+U?=
 =?us-ascii?Q?UvfqJJzdTunFTaTLx+gQrg18sQR7dVgVOqWKLMP+YkdpHMH3gueD62Na61tt?=
 =?us-ascii?Q?b+ojtiXu6jmwDG3cjucodn/qDFapykWYH8/HmS1CXYOAMiL5HPpCJ0UYZgB/?=
 =?us-ascii?Q?z7nI4SQ1pihJawFj1uvTohm5UXHLCKx02VVmO2pWMH50NFvIJnnHihmGpSAh?=
 =?us-ascii?Q?ibAind5MxbfWIm1rrX5TGqFsqaT98k3YSIIzOL1dpaDubiLFiTy4+XlSeW5P?=
 =?us-ascii?Q?Bww21WHOsIqE5oAmho0amBL03CAmwq4X4ztvz9u3axFNCT4O4FzayzxC9f+8?=
 =?us-ascii?Q?evzjWys+0Lm5dErsk8WRhDhgkPO7/Mi7ar+NN7/2veyrPyJBJEi09BKp/6k5?=
 =?us-ascii?Q?pGmpXnMG0gZ5ETqFYP+lhg0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12711A50851A5E4980C2F470C901C915@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f909b877-0c11-4cfa-e640-08da6880dd18
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 05:46:30.0220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FpLacHUov+0LYhyxCR0+ZU90pknYlqR3Jqyno9kPfhG9qy94qQMbHwouI7bYP2/C0e9Rx8+F99eBHn48jC2U3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2051
X-Proofpoint-GUID: 8esFCcikqejxgV5zy9D-PxgCzeMxCyjH
X-Proofpoint-ORIG-GUID: 8esFCcikqejxgV5zy9D-PxgCzeMxCyjH
X-Proofpoint-UnRewURL: 3 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_04,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jul 17, 2022, at 8:36 PM, kernel test robot <lkp@intel.com> wrote:
> 
> Hi Song,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-081533
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-randconfig-a001 (https://download.01.org/0day-ci/archive/20220718/202207181140.tqIgD0Jp-lkp@intel.com/config )
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d74b88c69dc2644bd0dc5d64e2d7413a0d4040e5)
> reproduce (this is a W=1 build):
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # https://github.com/intel-lab-lkp/linux/commit/1535f287d288f9b7540ec50f56da1fe437ac6512
>        git remote add linux-review https://github.com/intel-lab-lkp/linux
>        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-081533
>        git checkout 1535f287d288f9b7540ec50f56da1fe437ac6512
>        # save the config file
>        mkdir build_dir && cp config build_dir/.config
>        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>>> kernel/trace/ftrace.c:8082:14: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
>           mutex_lock(&direct_mutex);
>                       ^~~~~~~~~~~~
>                       event_mutex

Folded the the fix in. I guess this should also fail on v2, but 
the kernel test robot didn't seem to find it. 

Song

>   include/linux/mutex.h:187:44: note: expanded from macro 'mutex_lock'
>   #define mutex_lock(lock) mutex_lock_nested(lock, 0)
>                                              ^
>   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
>   extern struct mutex event_mutex;
>                       ^
>>> kernel/trace/ftrace.c:8084:14: error: no member named 'func_hash' in 'struct ftrace_ops'
>           hash = ops->func_hash->filter_hash;
>                  ~~~  ^
>>> kernel/trace/ftrace.c:8095:9: error: call to undeclared function 'ops_references_ip'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>                                   if (ops_references_ip(op, ip)) {
>                                       ^
>>> kernel/trace/ftrace.c:8103:14: error: no member named 'ops_func' in 'struct ftrace_ops'
>                                   if (!op->ops_func) {
>                                        ~~  ^
>   kernel/trace/ftrace.c:8107:15: error: no member named 'ops_func' in 'struct ftrace_ops'
>                                   ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
>                                         ~~  ^
>   kernel/trace/ftrace.c:8122:16: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
>           mutex_unlock(&direct_mutex);
>                         ^~~~~~~~~~~~
>                         event_mutex
>   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
>   extern struct mutex event_mutex;
>                       ^
>   kernel/trace/ftrace.c:8158:17: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
>                   mutex_unlock(&direct_mutex);
>                                 ^~~~~~~~~~~~
>                                 event_mutex
>   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
>   extern struct mutex event_mutex;
>                       ^
>   kernel/trace/ftrace.c:8178:14: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
>           mutex_lock(&direct_mutex);
>                       ^~~~~~~~~~~~
>                       event_mutex
>   include/linux/mutex.h:187:44: note: expanded from macro 'mutex_lock'
>   #define mutex_lock(lock) mutex_lock_nested(lock, 0)
>                                              ^
>   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
>   extern struct mutex event_mutex;
>                       ^
>   kernel/trace/ftrace.c:8180:14: error: no member named 'func_hash' in 'struct ftrace_ops'
>           hash = ops->func_hash->filter_hash;
>                  ~~~  ^
>   kernel/trace/ftrace.c:8191:9: error: call to undeclared function 'ops_references_ip'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>                                   if (ops_references_ip(op, ip)) {
>                                       ^
>   kernel/trace/ftrace.c:8199:24: error: no member named 'ops_func' in 'struct ftrace_ops'
>                           if (found_op && op->ops_func)
>                                           ~~  ^
>   kernel/trace/ftrace.c:8200:9: error: no member named 'ops_func' in 'struct ftrace_ops'
>                                   op->ops_func(op, FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER);
>                                   ~~  ^
>   kernel/trace/ftrace.c:8203:16: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
>           mutex_unlock(&direct_mutex);
>                         ^~~~~~~~~~~~
>                         event_mutex
>   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
>   extern struct mutex event_mutex;
>                       ^
>   13 errors generated.
> 
> 
> vim +8082 kernel/trace/ftrace.c
> 
>  8051	
>  8052	/*
>  8053	 * When registering ftrace_ops with IPMODIFY, it is necessary to make sure
>  8054	 * it doesn't conflict with any direct ftrace_ops. If there is existing
>  8055	 * direct ftrace_ops on a kernel function being patched, call
>  8056	 * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER on it to enable sharing.
>  8057	 *
>  8058	 * @ops:     ftrace_ops being registered.
>  8059	 *
>  8060	 * Returns:
>  8061	 *         0 - @ops does not have IPMODIFY or @ops itself is DIRECT, no
>  8062	 *             change needed;
>  8063	 *         1 - @ops has IPMODIFY, hold direct_mutex;
>  8064	 *         -EBUSY - currently registered DIRECT ftrace_ops cannot share the
>  8065	 *                  same function with IPMODIFY, abort the register.
>  8066	 *         -EAGAIN - cannot make changes to currently registered DIRECT
>  8067	 *                   ftrace_ops due to rare race conditions. Should retry
>  8068	 *                   later. This is needed to avoid potential deadlocks
>  8069	 *                   on the DIRECT ftrace_ops side.
>  8070	 */
>  8071	static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
>  8072		__acquires(&direct_mutex)
>  8073	{
>  8074		struct ftrace_func_entry *entry;
>  8075		struct ftrace_hash *hash;
>  8076		struct ftrace_ops *op;
>  8077		int size, i, ret;
>  8078	
>  8079		if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
>  8080			return 0;
>  8081	
>> 8082		mutex_lock(&direct_mutex);
>  8083	
>> 8084		hash = ops->func_hash->filter_hash;
>  8085		size = 1 << hash->size_bits;
>  8086		for (i = 0; i < size; i++) {
>  8087			hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
>  8088				unsigned long ip = entry->ip;
>  8089				bool found_op = false;
>  8090	
>  8091				mutex_lock(&ftrace_lock);
>  8092				do_for_each_ftrace_op(op, ftrace_ops_list) {
>  8093					if (!(op->flags & FTRACE_OPS_FL_DIRECT))
>  8094						continue;
>> 8095					if (ops_references_ip(op, ip)) {
>  8096						found_op = true;
>  8097						break;
>  8098					}
>  8099				} while_for_each_ftrace_op(op);
>  8100				mutex_unlock(&ftrace_lock);
>  8101	
>  8102				if (found_op) {
>> 8103					if (!op->ops_func) {
>  8104						ret = -EBUSY;
>  8105						goto err_out;
>  8106					}
>  8107					ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
>  8108					if (ret)
>  8109						goto err_out;
>  8110				}
>  8111			}
>  8112		}
>  8113	
>  8114		/*
>  8115		 * Didn't find any overlap with direct ftrace_ops, or the direct
>  8116		 * function can share with ipmodify. Hold direct_mutex to make sure
>  8117		 * this doesn't change until we are done.
>  8118		 */
>  8119		return 1;
>  8120	
>  8121	err_out:
>  8122		mutex_unlock(&direct_mutex);
>  8123		return ret;
>  8124	}
>  8125	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp 

