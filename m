Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0E0732677
	for <lists+live-patching@lfdr.de>; Fri, 16 Jun 2023 07:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjFPFCE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Jun 2023 01:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjFPFCC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Jun 2023 01:02:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB25269E
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 22:02:01 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FNJcoM013305
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 22:02:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=tq1zPQ6T3rRZgzrh8WXbgQZlkv1/DL/phCla1rjiBkw=;
 b=h99neH4iSHsyrv5KYaqzQU0Cbp3lMv2ndX3PwsV7gqI/cTQEt22TYim5zjArtqP41Fwx
 J69fGdcuxx+ePMhyCbLLYOHsWauJIMVqTXxcLuP74NzT/ukjSDhIr+6lnspDLbJep5BZ
 oLS1/uDcS7fhjCKk5jPCYrJb7awIt/9wMoP6oCvFXUrroJkAB14V05KQpFGB0DxGUGEd
 cOur+FZB3wZKuTrdFnP+dSCN178PDd7+NMMZUoExjfDAwdWvy/ua93Iuvff92xP8k+3H
 N1koPjTaJxnWbBNwW336hyrHTvawOze3TuHh9jL6qpHfZBNmnWz0wDt1IL6qtzYVBZsd gw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r81ggpv00-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 22:02:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6AWnsKviINAscxLKig5FtimG5gsMEBG4Z5W/nujcz/eKHIsCkjkbK1soZPsam2NEsJimwTLmOZzLbJbltT0DnrD0n3VxEGGLYf8IpZhRHvVSVHKpvLcaeqXnNdY4SgWYWVbNOxx6lY2LvucDnRF4iBkuSnhW8EIShFEfHMDHInGqsjqCx7UOsNqSw+1pthTIKjgdsjnf5LRjUSxwX+S3/c3JYSkZLuO6zINzmCLWvkG+rOwt8NOUqtvZOd8fdo7AzsvIgOkSabYdIT9eLmAaUZZjt620R/vSjTbAEvOozbb/YAovpQkcowDguG1WiIlz9uAzkz2fEedfMp4CtTYog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tq1zPQ6T3rRZgzrh8WXbgQZlkv1/DL/phCla1rjiBkw=;
 b=EHKAwqwEsydgKtutG3QJzPK/cs0JSeasfPIJbqPwUqe1DBqnh/OLLEmo9SJwm1SHssEso1+VLge7mwNumY2PdB82on4jL7yFccKvaqS+/YLw5ucCBsUu1oBde3rbgbPA/u8WzFTNDoBq1CLmvwXcB3c/k/fHLF2jLxeaXim4rcuyoGoQuRzVcNpiF4gpvz94V8jxsD8QV8bX6h4OS289XQd0X2NzJblKPH3b6WeEAMCEXDAPz6jW6cYFM28/hSqNRpiS3XoXvl9IjN1+30W2WYQjKahJ7N0p5Y4PHmufWFtisDNGePfYQlsaljbNLmde9wFM69JjXIY+/tyub65WDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB3857.namprd15.prod.outlook.com (2603:10b6:208:277::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 05:01:57 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 05:01:57 +0000
From:   Song Liu <songliubraving@meta.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Thread-Topic: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Thread-Index: AQHZn6r1VuNYFv7wzUinZRrB36Nwc6+MsomAgAAtbQA=
Date:   Fri, 16 Jun 2023 05:01:57 +0000
Message-ID: <EE806082-EB5C-49BD-B7A7-FFAB3E6340F4@fb.com>
References: <20230615170048.2382735-1-song@kernel.org>
 <4c05c5eb-7a15-484f-8227-55ad95abc295@huawei.com>
In-Reply-To: <4c05c5eb-7a15-484f-8227-55ad95abc295@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB3857:EE_
x-ms-office365-filtering-correlation-id: de420ba9-a475-4300-3ccf-08db6e26cf65
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0+4mYpC0e0y0941IrL9f4RfIW4RBa4kZC62JcJhjrDD+MmAOnZz1p4mDyJky0oM4smV9HuHjKIuXfMUy2lUuXXorhkYB2LB8T4evl1bIHsnGsgzbqvjN0RjNGRzcJFr+Z28RSJOy4Duv7YtRMX0+UNwNdbYysFrox0o8lsHoqSJn+XF5wobatqYMbRqwSEhCLJc1GN8ybokLtZcLTAEstJKOtGDQsjMbK6E/NfGWZRJihyV8NUPrMTf+/6OxECElBNXuNbYmptnw7U+VZxQzRH5tUk9LnL2irrHZFR8Y45u92WXOHe9JoWPbMH16EXTsP0HU2vgE8h/Al1xWGk8cbv+Y+HkP4L//r3q2wrj6fWBx6vaifJmxOlIv1iVKLshLVzlTxibxNcrRAMIdyOWlTD+pvH5W1dv7hJDP0PpyE1zsWNks0mNhqERqa8tOdyzTndaE4AxlwNC2/xcnEVnL/JiMzj9p7fQYsq9MQINhaUovks+8qoqdhUgg/Po4iI64G6M9SVx2MIpmvVIIHbX3is/WNfXK59lWGAEduWhTCpWhGjmhK8DjVopr4IlwJmj2TxdlqciWe97378wDQGvQw9D7gDQdeLo6/erT0eh2Frbea/1XDooQgJlNT0LyOvGMCOmHXj2iY7uWvfmv2zfVpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(36756003)(33656002)(38070700005)(478600001)(38100700002)(86362001)(122000001)(8676002)(8936002)(41300700001)(6486002)(91956017)(4326008)(54906003)(316002)(5660300002)(53546011)(6506007)(186003)(6512007)(9686003)(2906002)(64756008)(66476007)(76116006)(71200400001)(66446008)(66556008)(66946007)(6916009)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?32uDD1RnE1aTkANt9QO3EhigcHyZtkyWFdPgpMOKEx+uuUQ/sfNeTT3uwD2a?=
 =?us-ascii?Q?cWWAVRSdqrdXtvZaGRtxWF1WReu+zcyNDQuuFh7vhR1s6Zhz5Wycvbo9cozx?=
 =?us-ascii?Q?1aiAKRgFADuKZSqs+/b5fNU9hZA7pYMhEYH8Dh6pUs1weies8oEOeK77IXSa?=
 =?us-ascii?Q?BT3XM5xazvTSzhl/hUkmp99f0wzzYVcoOwC2XtHG9imUu8oNzvfZj1nw1rvr?=
 =?us-ascii?Q?c7nAk/ugkNoVpyBTFZU0Hl4a7c0sSbjt5O2fjNmj10KKyCQ3B+Av5mCahKHr?=
 =?us-ascii?Q?eApo24uLBYsegdtfNmnfGEsZK5SO2MyodOfx0pK5Vq0N4egW4sWtuIv2BvWN?=
 =?us-ascii?Q?ZD/QAVWyF24sQsML2iSj7ejv+a/+4uU8S4uj5SnqQNa8EeH1bkYtyOj9ZKtW?=
 =?us-ascii?Q?zHP9HruDuayHKb1iA7GVva9LuC2eKLanhxC/xeT3QWd3j6oWzj/A/EdZTzN3?=
 =?us-ascii?Q?8gut1KTp6tDreprlCKMITbJf9n9quDtEOKpSYQyhn7sJdizbIbI43C4WYBvb?=
 =?us-ascii?Q?MDAAjV+DcoV6ckUp/suyFyZe+ObRMsImSLflJNjC3zERUKtSfjtv7s7LW7Fo?=
 =?us-ascii?Q?b1YUAIpmUKPDr80NivI4NG7ItwavCglUPTCl6jg+3kmcxOvbhyaE+QfuQMtM?=
 =?us-ascii?Q?9ISdkefJ8TplZRBNt/SNWqfY2aI9AxLS0LG+en6+D0eHmura+hOwsRJyq+d/?=
 =?us-ascii?Q?84Ox0tThifyhEI0Je6DuDbK3OjmJ3X3uuX2OCZ7hTLWfxJXwG2tNCUfwZVZb?=
 =?us-ascii?Q?/AoNPf2JicRSQb5h9crAEzEqb/WwUSWa8Or8YbyN+0NCtpJs7MBh55D1LMAE?=
 =?us-ascii?Q?uUdw/8hwxjRUKv+9xi218iBGf3DyFrpaqqmYxOuUl4Bn4tzSBlIMtTdw9XWo?=
 =?us-ascii?Q?zG8c24yEFtHlhc3AjfGKieeCxkJGau9/mmLtbdVvuFEeUWlvR01uePseNaw6?=
 =?us-ascii?Q?wmX/FCafaQCC66lF4dIwzpxtX++d05yuVdqdHa5BXCidgzoEokrS7gjtCIND?=
 =?us-ascii?Q?X08VqkvIlzKcS2mU/MMbnF/m96yxJMBpOmm5Qd1buoem0tEP3vyl1RSHFaiJ?=
 =?us-ascii?Q?gh4/yHSwxQhEzEeaR30f2vfCvGSrXvC9FwDxYIB03wfDnTZ6+QBWxLRUGPGV?=
 =?us-ascii?Q?TChwBWYhSJwMdMOeWnD71qBWeavFGHOIPQBjPiCSHiJohAfoqzG4nNvHAGoz?=
 =?us-ascii?Q?Bqk0E8PjWyboOWcVelw05hBPiaYyqP2gEpJzQSsz57vLI5EpBj2eYJ9sqRUy?=
 =?us-ascii?Q?OpYPEO19IffCboS8Dtvr3zEnpyAWSmIr1GXFUVrfGMHvDthq50hH2QLDqn/k?=
 =?us-ascii?Q?OfQfw1iiCnJYHNMWM9UJF9XlhTsbX2txZoPDOFTh0d0/aMVTvn0BiWcQQ/Ze?=
 =?us-ascii?Q?ih29IkBpic35Cc957L/R6xeF2nMryief+MV7vu9jpWk0dBGeRceTqNyPOjdO?=
 =?us-ascii?Q?tX18cv3ixNW7wbxqzk8Osmb31XoNRomuAJb5PTJCZcki6O5z6UIACTm39hii?=
 =?us-ascii?Q?WnWZTZFxcPuT/qyn1oQ3RS+Dil3i50wdBCAOFBVv1cZdMd0IbzFBKFdM0I29?=
 =?us-ascii?Q?NJBOHE4LU13vJqpWOUvRInYayNVa0TecT0jKrRCGhdaeG1MgznHYYfkspMOH?=
 =?us-ascii?Q?eSlgfNChhdYgq6mP+GX/iLM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26E08C0CDFFA374A8E955A52CA60173B@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de420ba9-a475-4300-3ccf-08db6e26cf65
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 05:01:57.0273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bZEQ//2dQjHMmb8BGrxJrjwJAPxh/nQWD4Eoj7VqEgycen9zCx1Y+4sTubYramWEy3+m7GWm0HIhHBXTVaiGaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3857
X-Proofpoint-ORIG-GUID: qd6jODn5IjYv1kp7udu6zLcFHUgwOWjm
X-Proofpoint-GUID: qd6jODn5IjYv1kp7udu6zLcFHUgwOWjm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_02,2023-06-15_01,2023-05-22_02
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



> On Jun 15, 2023, at 7:19 PM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
> 
> On 2023/6/16 1:00, Song Liu wrote:
>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
>> suffixes during comparison. This is problematic for livepatch, as
>> kallsyms_on_each_match_symbol may find multiple matches for the same
>> symbol, and fail with:
>> 
>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> 
> Did you forget to specify 'old_sympos'? When there are multiple symbols with
> the same name, we need to specify the sequence number of the symbols to be
> matched.


old_sympos is indeed 0 here. However, the issue with CONFIG_LTO_CLANG 
is different. Here is an example:

$ grep bpf_verifier_vlog /proc/kallsyms
ffffffff81549f60 t bpf_verifier_vlog
ffffffff8268b430 d bpf_verifier_vlog._entry
ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
ffffffff82e12a1f d bpf_verifier_vlog.__already_done

kallsyms_on_each_match_symbol matches "bpf_verifier_vlog" to all of 
these because of cleanup_symbol_name(). IOW, we only have one 
function called bpf_verifier_vlog, but kallsyms_on_each_match_symbol() 
matches it to bpf_verifier_vlog.*. 

Does this make sense?

Thanks,
Song

