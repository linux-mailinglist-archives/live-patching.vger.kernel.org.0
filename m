Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C6B5962C1
	for <lists+live-patching@lfdr.de>; Tue, 16 Aug 2022 20:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiHPS6T (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 16 Aug 2022 14:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiHPS6S (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 16 Aug 2022 14:58:18 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1422101C5;
        Tue, 16 Aug 2022 11:58:11 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GHdAEY025564;
        Tue, 16 Aug 2022 18:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=PPS06212021;
 bh=ldhgIZEwqAxQmviAOSUhwyeBvjr91AjlwyYSvOSf3B4=;
 b=FK1T4YEP0fq9K8GCFHSbg9pYEsuH2R+LsnoGRUN/HIb58V0cd8QfHJQbpIw1RpIYu/N/
 EnnGUu8FYdR9Ng0qvU9c6ILQ5Xy+RRQoR0N7DwatgHUzNMYxMq+NmruYavXgrmvCAFP6
 qaQjPsZCHSxCGXjJG3SUxOCLITyk4h40ll4aPSpdWpWz2ZHmNnjI0VFO3mFYPWhkhz4z
 7IxNr942iyruWy8qPE21UHKORR7OzUHFPsrJ1JcoiXgdK6vepbUcIR/ldjdugPwpV4VR
 I398V4Z9+eys+h5zL2YDH7AYW0BAVHpdu3NUtNVyEexRvcMTYZgnR4wyAcK5kK9OdG2M pQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hx160tv56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 18:57:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IR9bpEmjghDLPMx/y+ooUL95Rpot9vBGDbOflG3qTO1UjD5a9q95mnL0kW9gM8mJPtRUg7pXi4XPcen4IUW9i+HB5gnDfGpiYyznCTbjUPCjVxYceC7KTdVNjFA361l77SyVVxQ/GCBJqyQXuA8pBagM/H30+OGpwDSyHpSzMw8vPCBtMP8qfNyOqox/pyNJ8Hci2M2Q13tr71LDpaSIjNiU16zi3f4vS7wBnItj4FnHWyZTAiIG5XGaG2KPsEks+07e8T/eSzX6DcDS457cjGEKaNW76g/UwTns7XJO66Vbd7fH++msgw8nKhxeWrGd5AJSt/obCSLROhKESX9I5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldhgIZEwqAxQmviAOSUhwyeBvjr91AjlwyYSvOSf3B4=;
 b=PxLOISzmKq1bECBKZsBxxIqNWF6zfURRacge/clYilyF1nwdzRGV8dGV5hbDqRq1wCDQ4FFfEuWF3uhvEH9Q3y/XLEHib0+JMAIrE5r4kYExwn26xWZy1l7+idoiZfGxI7KCF/DQSmMwj1lamM1mBLsjkSHTnRVHT9FlCrhmvmAEATKASzUvEiw3yy28vyxg0EPae1LaN4rD1gXJhuoIT2uH6n3Sfg9TqsBRFJnKATr2h5nTzaWI2TAe3JKTLhFzrEMMf6+y2F8neAG2EO5hGOARszL+a+mkwEsbKhstrAEhp88PYwsGvoDlAoQhaLgOE2jX88SXm6Wor06r/+S9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY4PR1101MB2069.namprd11.prod.outlook.com (2603:10b6:910:17::7)
 by SJ0PR11MB5135.namprd11.prod.outlook.com (2603:10b6:a03:2db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 18:57:20 +0000
Received: from CY4PR1101MB2069.namprd11.prod.outlook.com
 ([fe80::9898:dadb:f62b:efb8]) by CY4PR1101MB2069.namprd11.prod.outlook.com
 ([fe80::9898:dadb:f62b:efb8%11]) with mapi id 15.20.5504.025; Tue, 16 Aug
 2022 18:57:19 +0000
Date:   Tue, 16 Aug 2022 14:57:16 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Johannes Erdfelt <johannes@erdfelt.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: ftrace regression with CONFIG_UNWINDER_FRAME_POINTER
Message-ID: <20220816185716.GA75067@windriver.com>
References: <20220815195828.GE3948@sventech.com>
 <20220815160646.0dca7227@gandalf.local.home>
 <YvqpnfM9ZdRO6oXa@zn.tnic>
 <20220815202946.GF3948@sventech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815202946.GF3948@sventech.com>
X-ClientProxiedBy: YQBPR0101CA0226.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::26) To CY4PR1101MB2069.namprd11.prod.outlook.com
 (2603:10b6:910:17::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf247c8e-1c23-4c24-de5c-08da7fb92538
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5135:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8SOf4uk0wim8RygIY88RgPi2uPs/6qUtfm12/m0v41/83ZLcFeoD+T1kB47T4HfzP6JtIPG89LK67081PNu8UhzeLK3H2t56V/JVNDosKmw4oh633AyFyyNLpYZwyhrh4UUcWNt2ReJx+monsOv/lOEkTdvTLqJ/b9vFqSrU4xqk1lf2xqZ29z4dHZJ5rAQ17belB7JIHlc/83Gh5StJx6D1B4jMDGBJ2e7TCEpSWYReWoFn+xBx96aCNdILryhuIaO3KgMgSKaBiXkTtPhLpjeCemHs2CvurgyrXTOn3gkKGleIBEchRkGie2NsTyGtQJxq1sS5KKox7Boun2ctnAmP6IKc+fw6RgGdpce6T7ALWawmGNMkDo6sp4E3BmjGErlxyG/U98QtASgPQl2SQ7ya80UK4rhIXaLoJGH4y491CGRl5GoD55u8AFHZIvhG5RJsSJlQ3OnbYc20m1rjAZGcHKbwyGup2oPK/q/NlrifDu9auVKPKv2pfjM7U1sYdiPWAR3sgsTR3+xOI5WxzPE07lzKfl/k4YkP9OD/BL/GuvCaCalcJd2EZHsWTEy9O9dwNgtmhsPg9nEMI+4y+HySI8Q2BqdE2847Pd5nuhrA6l475gDSvei7pkKv0ibyIXtbKcyQDMp2gNJQdvxsfnIru86mIFn2dfrjonSZw8FyTTPEVuv4vwfaIe/xqWpS/yl62IQpzYCEM+B/HyCU7DQdI63q/gG59puwkfGG77VvKmXfvejdKXst8SKIfy+xJvqiIRGFNiOWwjaq4WgsGhY8SgVcU2X+sl90oksBuTBo2AH+Ee0YW1Bqnaoxg0+y547zTTBs+a65WLp6MCpDfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2069.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(5660300002)(6916009)(52116002)(6506007)(86362001)(26005)(54906003)(6666004)(41300700001)(8936002)(6512007)(66946007)(6486002)(66476007)(478600001)(8676002)(966005)(66556008)(316002)(36756003)(2906002)(4326008)(83380400001)(1076003)(44832011)(33656002)(7416002)(38350700002)(38100700002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q6qhFpGqMxVs8Zj35CYNeR1R8qSy+W/SQ3VfaHzMubCYRiVXlhpeumEl5aPQ?=
 =?us-ascii?Q?zxazCbmsZgZGctEZxmnaCkEo6bKiGIsKQg42OUwZ5tV70tnwBylRNyYFHpFv?=
 =?us-ascii?Q?V8gZ7uk7ItpR+IDM2hsi/7iZUsAiuP/oZ0jsd14y6LTlc46u+q0mYWBcO6V1?=
 =?us-ascii?Q?vX0L81g5De4IlANTqTJdlYgSaptacHGAxbT4+w29YLjLVZNIviC5wxTnoc+G?=
 =?us-ascii?Q?V/eI41R5uInmh+RRUH3y44gWSkuU0ijSQlMM4zOSDW+g/VtChwpax+HDgQLu?=
 =?us-ascii?Q?jEctkCnC1vk8tsaVvnKsdkWWB/uq8v9Cc7KO1di4s4DSiPDEAlBRcaxiVIgb?=
 =?us-ascii?Q?S8z2+r40ZlZWdWVE+In9cCQZB9uAej2YknCVKsNxY3BHzsEQ+Tx/yE+CguA3?=
 =?us-ascii?Q?RQ5qUdgjCKAWz7jla02vIKGRnp+x4CAXV+xK+PEFnaLRMDEMoguFJ2TmN5P4?=
 =?us-ascii?Q?ROhWB3DeGIMVwYkD/+wFgtKtm3yOK6yPOrUjnTAS+GfoAusOtLb8i3QY8y+3?=
 =?us-ascii?Q?WB13evd/AoF4ZDszRaCyS4k/ePScmrsZB6JKZ20N1VhS9d/UKW8E+91cM18s?=
 =?us-ascii?Q?hMsLLsBMR0CQ2RBFv7qHSU2V1FaCAA754+hlu5CyIyuwPeejRKKs0S2ZF/Ei?=
 =?us-ascii?Q?xdzB6wpR8LzA9cM3UcITQL9Hdd9dAcr40MDfFuVH8cUfgXWmVUvPeCEU9O9g?=
 =?us-ascii?Q?+UEvLtInv+qacr1Ny6f/xHhzjaz8na2A+lssOBIww69xy26K751yX6T/qY9j?=
 =?us-ascii?Q?lBE9KqyF22SRfKY+DQYCMda5I9hIj6PuPKDVYE4Yt/tGhM2v5FY0Zpa24CYF?=
 =?us-ascii?Q?Py/Fk5XQ2a7L43NakYtlZQFsKwOk0IavJKlrP8Im7N9AcnXG8QIRPYV4WfKs?=
 =?us-ascii?Q?6//eGuFomtmc8Acm/hGjEaTtouraWvqXTbHOzvZmCgofPkAzOtVevQ1DbUWF?=
 =?us-ascii?Q?e2kjpTbNetj9K1acAmHjFeejfsF7h/h5WKDqdnWYGBA50tJHuH24TAooeJ7W?=
 =?us-ascii?Q?6C9AvmJ/nrp+tYqmCi2tTnurZP5Vaq+dXJZf2x9QQsCqnIO5tfQyhsDUvKRp?=
 =?us-ascii?Q?9IzsTLB3psKdy8KEDK38aK92wuAT8JZrwuAZzmqY8QUCBR+q+Z69GQKXcM0R?=
 =?us-ascii?Q?wHOc/UfudHWrQQppztjgp/ZwDl83KW0cj6r4wetv+ZfjPiRYveiPrvCXNjYM?=
 =?us-ascii?Q?tSybsGf+dDzEmZGPDnN4sS57zRi4ctxRzpC+Qy86GCoJDRdSn7XsQBj2gh1b?=
 =?us-ascii?Q?N6ept8NRY5ECdzTgIV6rEI6VxL0MOPHhGEGOt91Z+Ly8bQWPGa3qIQFUk3/C?=
 =?us-ascii?Q?CFfd0K3BRoAPOkZsLtD/85AqHI27Xh3wvgNGRoV+WdMKvmQVzuttTV/7EgQ9?=
 =?us-ascii?Q?MteqcnqguCo1MofLZn2qFt42hTv2XMef78uJyao897mkfHhmD8rLGmN1l4yM?=
 =?us-ascii?Q?RDUCijaiezXkO5bVBwKPMk2HSywBpUxK5l5U9OOijrD533FFBdm92jE8IANi?=
 =?us-ascii?Q?Lpu8xvzfPlN/eJZFddbS4DRuQkdEQUQpOxkaJpi+ZkU7Oq8ZU5OSzbeGUywp?=
 =?us-ascii?Q?gXk7KSBoZWS4xmaMcNdmYWdsfgNkf1IHcTcfcG9rjfkLq57l9woNd0966uBl?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf247c8e-1c23-4c24-de5c-08da7fb92538
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2069.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 18:57:19.9164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zoZfMGgQMzNrZo/pYPtIp2NJwt9yxyPJstMiRleDrP6/Mnc7hMV7ikbmmGJAA8E7F2HIiTZIRyJvo4lpCu+/VE5xcz63JRDN3SKry2IJtQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5135
X-Proofpoint-ORIG-GUID: wa7WyiT6GRDMJ_C400clTCj3S2pj_QEN
X-Proofpoint-GUID: wa7WyiT6GRDMJ_C400clTCj3S2pj_QEN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160070
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[Re: ftrace regression with CONFIG_UNWINDER_FRAME_POINTER] On 15/08/2022 (Mon 13:29) Johannes Erdfelt wrote:

> On Mon, Aug 15, 2022, Borislav Petkov <bp@alien8.de> wrote:
> > On Mon, Aug 15, 2022 at 04:06:46PM -0400, Steven Rostedt wrote:
> > > On Mon, 15 Aug 2022 12:58:28 -0700
> > > Johannes Erdfelt <johannes@erdfelt.com> wrote:
> > > 
> > > > I recently ran across an oops with ftrace when using the frame pointer
> > > > unwinder. It does not affect Linus' tree (tested 6.0-rc1), but it does
> > > > affect 5.15.60 and 5.10.136 (at least, have not tested other kernels).
> > > > 
> > > > It appears to be related to the recently merged retbleed mitigations,
> > > 
> > > If you believe this, then Cc those that are involved with those
> > > mitigations, which I did.
> > 
> > Sounds like this one:
> > 
> > https://lore.kernel.org/all/Yu2H%2FRdg%2FU4bHWaY@quatroqueijos/
> 
> Ahh, I missed this in my search to see if this was posted already.
> 
> The patch in that post appears to solve the oops I'm seeing (at least
> on top of 5.15.60).

Note that if you reload that thread, you'll see what you tested was not
a full fix - a series of three commits is pending for 5.15-stable now.

Paul.
--

> 
> JE
> 
