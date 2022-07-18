Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CC3578781
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 18:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiGRQhB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiGRQgu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 12:36:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4372AC6F;
        Mon, 18 Jul 2022 09:36:50 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26I1S1mT022610;
        Mon, 18 Jul 2022 09:36:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=TeQY+xpRQFbN43ExUqBhLxXY3y5PjdgXOQiq8EsN8aE=;
 b=DSuOPOmrr1H5qNTUlZbXpTCfv4VAhEQSD4hz0xWBo3/o0XFd5l83yqqzR8riC4dFkebO
 BFjCUqouftu7n4bBQ7dOLe/xdptrhVNSN/PW+Z7t1AzuHWBouTK5/8seN+JQ0CQh/GBq
 Gpvp+LeaP8dks9KNKdM8plDwIugYILLlUs4= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcpn65kf0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:36:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJH7AyNIaJsRp5OuTy5pF00VlIKZAdY1wxCu/+ElK6H+aQFkYNajWqY7IG1d0nNOZAuAz+a3MqGQBVioinnGVYE3vzOzoGE7F0/VqtHIqWczrn9idU4L90/30o2ocfnXiIA7zh2QPaSHoGe2iAN1kKSixWrcA/jJHFvTqtuzw/qUYJEIu6FPMcOBHpUlc3aTrauya+ItelEbdtykigRTCtTQJ8QWdrf3NiWaLVN4ai/03qEH63577S+R9orBE3GuCUuT4sw+wdKyHHRuoNZ45uSFxI6re72OeyV4IErYJBvfWxYHebzhq6NR/SXoa72fDBsKqRVLtUkc06mk3/Fdpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TeQY+xpRQFbN43ExUqBhLxXY3y5PjdgXOQiq8EsN8aE=;
 b=llEE9yGey1WOdzGSorXMgyN9Iz7OQZXu38IzvCZ1Rn+LHvmOqXgttyNpkuZ5iY0PsngediMClqJxl/X86SXMxQ52ADNfzwC/AQ1YSPmruDndOZwNc0++6mCXgSkNgRNkV3rCzTOlYIbLK0UNGLLLlgMUwvsd7bIjadBplT8wpmX+8yNoc5CblkdJI7y/D3QofURJJtrDC3hBso7K46GZ/Rti0aFdKTtxg1AL/fOgeRgStzxXcgCRzKFquad1SZyadmGw4VloFOxY3gviW52gAEkQ4uEcSik38xoX/6EpxXepKgsDEuheurEEymO42lvS68oN6aS67sczFxML+tcEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW5PR15MB5169.namprd15.prod.outlook.com (2603:10b6:303:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:36:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:36:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH v3 bpf-next 1/4] ftrace: add
 modify_ftrace_direct_multi_nolock
Thread-Topic: [PATCH v3 bpf-next 1/4] ftrace: add
 modify_ftrace_direct_multi_nolock
Thread-Index: AQHYmjtZKdCAk8gdFEio+bCmUefGN62EFXwAgAA/L4A=
Date:   Mon, 18 Jul 2022 16:36:46 +0000
Message-ID: <0E284A30-F185-4557-B7D1-0F6ABDB24BE5@fb.com>
References: <20220718001405.2236811-1-song@kernel.org>
 <20220718001405.2236811-2-song@kernel.org> <YtVXHDfV8HDwAm6G@alley>
In-Reply-To: <YtVXHDfV8HDwAm6G@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2478e238-75cd-40fb-acf6-08da68dbb49a
x-ms-traffictypediagnostic: MW5PR15MB5169:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: np1H1bsMpeF606X+qauiEXIH7gwThxvr3cLbWXsPUIXGz8U4xs+//RF287/eYu0ifD+kfUQJSV/ANDc6ScC1VGZ/UrRGTj+IzXK8ecBbFQKC60rz6q/LcxapGEIHP/VQ0cgn7BqPSQkKNa9SmSexKZHpiBO9VEHUryewpAGQdLJpNA+d3/b/uJBfnZqtU5sB8Jqt+4wrShmHdvRR27FFKoiSxVtGLzKVTxXH+X3erawxEv8JgSxOxvU+ViCV6iXTHV1YO0Q0FL6n5+MF15HNaynuYNlGuVr/NQ4zR+RF/G9qKMnqXl5OajZc/qlj/eucdNWWymj9mY4P0uP9dYWKojdhEKMTc1EzM6E8fEPC2CKur2G7t1T/8MsuZy8kn1197XFx2yw1IKzA7qJlb9Rg9j7hJw5WjE6TxxJr6i5ahaIcJeEUC2nXyndHBFcoEeV+7ch/nNoSVYcvO6jmDz0K6T3mcagHQ/xiBak1rOIudbQ/dlQ4onFxzR9pWxc/fRchPL3Jg4wlMM0YEhewkqDvmDjjByzkxmDbcbIgxlPDAzcfwMYxuKFkTTxpTKZz4PZsbw3P0izHl/6RgW61FTUXGUUfef0VVC08cnPOzu+zwfplGZtvkg/jrpgX14nhxw3bZU/tjhoUQisQcBaZgA16797bAN8lMuG8DQEjQwfohSaI00IABPUGpn2/mjpowTEOcxF4Mj2PmKjNdCHkl6c4WaDDVlMlMf/j8uvAA8eqTSRLUt+EDC8oB4NpUON0GG5BpkpT5+9QgPXcbX5Yi9uKGTiYpj9YMAmf3w7NLkbp9hzvadUod7fqkVva/vilTNSD0TH7BBC2SltAezL8/1HUETz/8zS15Hlml5yRR5R968Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(6486002)(41300700001)(71200400001)(478600001)(2616005)(186003)(6512007)(38100700002)(122000001)(6506007)(53546011)(66476007)(66946007)(38070700005)(83380400001)(76116006)(33656002)(2906002)(5660300002)(8936002)(316002)(91956017)(6916009)(8676002)(4326008)(86362001)(64756008)(66446008)(66556008)(36756003)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PuW+Zd+7I9wmFM76hXD8Q+R5lNdJaN0LAnC/rLp8qoAlvPDW09lY+pPDXyCe?=
 =?us-ascii?Q?lXHePeBsVDT+e46IoQ90naQee+KqRILFqyPvRGLtfW+GT88snTV6qRz5dNVu?=
 =?us-ascii?Q?TdZzToyv18JncXf5kWPhHhJx6UfDAXSToevpKLl5Tfa707OWXd5W5w3byQKc?=
 =?us-ascii?Q?DyTzx6/lSePyv0KBBs2SN2Ut9lJhcySl4fPxqT7Ff97viUbYEHTRh0IpGlzG?=
 =?us-ascii?Q?4bnF4vfKaPI+/uQKzhWt48EvcarBr1ekiO5teoZuHFp2ZRJXcSQ+7U11eE4Y?=
 =?us-ascii?Q?1L4DbN0szhfm5NBkeiosX5vId4TijVBOVbmJSPulNjRl8Iez1QeoTENmWvA5?=
 =?us-ascii?Q?iZqeBL787adQhOowTds1wgvZYHlxSw4yFTeWJbgoZnh5H46pOAawu+mNyisP?=
 =?us-ascii?Q?pBLh/4UYVhiqIzQRz+29AEaAzPa63LdzOTzoE0TaeR2lsnmq//n+3Asuz/Z4?=
 =?us-ascii?Q?pDufJ7R932d1pWAfkvL3wi/LSE+i9+EgQ3Uss0S8mqIDUDi0kdnTm3r4N9rs?=
 =?us-ascii?Q?kKH+mJ0JhnyFnSK5dK/lXCSy/MNp/XB6EfhSxp4Y9Shok87NsWwPtIGL1Yyk?=
 =?us-ascii?Q?lUH/TsD5PpUU7ucVok+6ua2VKW3w7z+6G1/098fEauo9unwzgIK9wFqzRNYq?=
 =?us-ascii?Q?DKaUBaTSZG+D/6efi3fFGqGnKVSinPG3eNZq9vxT9p+uf8sRVO9CLMzUm+wu?=
 =?us-ascii?Q?tSVvY7B1IQvuyRyjQ907sbSyZ9wgRBYS2MuYUw8z5yvgDWfgH+wRGd1VLevB?=
 =?us-ascii?Q?xDabNSVIm0gFRZUY113kF6823YwIiVrodoM60QJo0pGOf/WK1kpFf3f4HfXB?=
 =?us-ascii?Q?BB6Dgo+TFh2HmmwFULHFCVwbDhYvsM/UrJW979Wkq9IhtmD+0ihHDt01jJoY?=
 =?us-ascii?Q?ZK8lXI+Wp/0yDE6lyuGKrbHY353Y8DRqujxzhvrEmlDFU8RYaOv+svW4P0o4?=
 =?us-ascii?Q?kZ6CUf05GS7Mp/H9ZzIknSxsItqnf0b/0WY0Tcu0hJVk2+vuiFTSd1YibeDz?=
 =?us-ascii?Q?nuTPNmW6ZYHKJVfAGp5EoSu5Xu2zYJLl6Cyo01kpO9G0vonPM4jCHUc3Jhh/?=
 =?us-ascii?Q?wewfsvTMMYyLSFWl0zKlXha59h0IxLr774+pbwnpkbv6YL6/BLOUOAUtuH6A?=
 =?us-ascii?Q?haVRzVat0CH9S5xmFN1tQ0UmI1S1wvAograh/JqDL9ipvJfrqXKURBeUZ+Ap?=
 =?us-ascii?Q?XPTEIthscC5wJIYK/yvBuh6PDO2o134nWF1IaW9fbVEuS6a2pOMuKl+Asj4I?=
 =?us-ascii?Q?dkAdZrtrF5fdB5kpFbZnS7BsTsMiYSLDGg5vIDGccHno7pUUrFjo13vVjUZ2?=
 =?us-ascii?Q?Iu4URiulW+4cXTV5m2Xo3Yiw6NT9Gh4r9na8+WdyeJ8iUs4nx2l517b6cbGn?=
 =?us-ascii?Q?F6yLhLGk7TkeBpxHZjd7KW7Aw/hDwhqtp6HlMc1D0P9aPxFdaOV2eYEvoTfE?=
 =?us-ascii?Q?n/Uz5dEikE+pvwYoJqLZZU5A+NVYcFHFDgH1iMRyOAXnxBpdl5bmvONzHsDm?=
 =?us-ascii?Q?re+5aLI/fOtYbmo7jsc1aoYynFxLpLe3Z8CAJbSqtY6MvyK6jGVVMekIBfpn?=
 =?us-ascii?Q?4QmNaRPBIcqFuE5cjuIlQHLSZa/MPmbzAbUE6WQkK8IgVNRkoeJKDRmhYkV7?=
 =?us-ascii?Q?JAWGSTWCjuITvpqMBXFT060=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B7226FDD129F449B8C01991F80D0206@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2478e238-75cd-40fb-acf6-08da68dbb49a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:36:46.3352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5afn8yScyVW2qJ+HQkMI2GVvznbbVQEfCZia+SsqLH9KPkn8uQNLeBN7ZrkVWHdc+6eOL9/Y8uFDG1MKBkXR0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5169
X-Proofpoint-GUID: dSe8w_QFXXEJI_UsGHgPpPEhSHIjXwBg
X-Proofpoint-ORIG-GUID: dSe8w_QFXXEJI_UsGHgPpPEhSHIjXwBg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_16,2022-07-18_01,2022-06-22_01
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

Thanks for your quick review!

> On Jul 18, 2022, at 5:50 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Sun 2022-07-17 17:14:02, Song Liu wrote:
>> This is similar to modify_ftrace_direct_multi, but does not acquire
>> direct_mutex. This is useful when direct_mutex is already locked by the
>> user.
>> 
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -5691,22 +5691,8 @@ int unregister_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>> @@ -5717,12 +5703,8 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>> 	int i, size;
>> 	int err;
>> 
>> -	if (check_direct_multi(ops))
>> +	if (WARN_ON_ONCE(!mutex_is_locked(&direct_mutex)))
>> 		return -EINVAL;
> 
> IMHO, it is better to use:
> 
> 	lockdep_assert_held_once(&direct_mutex);
> 
> It will always catch the problem when called without the lock and
> lockdep is enabled.

Will fix. 

> 
>> -	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>> -		return -EINVAL;
>> -
>> -	mutex_lock(&direct_mutex);
>> 
>> 	/* Enable the tmp_ops to have the same functions as the direct ops */
>> 	ftrace_ops_init(&tmp_ops);
>> @@ -5730,7 +5712,7 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>> 
>> 	err = register_ftrace_function(&tmp_ops);
>> 	if (err)
>> -		goto out_direct;
>> +		return err;
>> 
>> 	/*
>> 	 * Now the ftrace_ops_list_func() is called to do the direct callers.
>> @@ -5754,7 +5736,64 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>> 	/* Removing the tmp_ops will add the updated direct callers to the functions */
>> 	unregister_ftrace_function(&tmp_ops);
>> 
>> - out_direct:
>> +	return err;
>> +}
>> +
>> +/**
>> + * modify_ftrace_direct_multi_nolock - Modify an existing direct 'multi' call
>> + * to call something else
>> + * @ops: The address of the struct ftrace_ops object
>> + * @addr: The address of the new trampoline to call at @ops functions
>> + *
>> + * This is used to unregister currently registered direct caller and
>> + * register new one @addr on functions registered in @ops object.
>> + *
>> + * Note there's window between ftrace_shutdown and ftrace_startup calls
>> + * where there will be no callbacks called.
>> + *
>> + * Caller should already have direct_mutex locked, so we don't lock
>> + * direct_mutex here.
>> + *
>> + * Returns: zero on success. Non zero on error, which includes:
>> + *  -EINVAL - The @ops object was not properly registered.
>> + */
>> +int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr)
>> +{
>> +	if (check_direct_multi(ops))
>> +		return -EINVAL;
>> +	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>> +		return -EINVAL;
>> +
>> +	return __modify_ftrace_direct_multi(ops, addr);
>> +}
>> +EXPORT_SYMBOL_GPL(modify_ftrace_direct_multi_nolock);
>> +
>> +/**
>> + * modify_ftrace_direct_multi - Modify an existing direct 'multi' call
>> + * to call something else
>> + * @ops: The address of the struct ftrace_ops object
>> + * @addr: The address of the new trampoline to call at @ops functions
>> + *
>> + * This is used to unregister currently registered direct caller and
>> + * register new one @addr on functions registered in @ops object.
>> + *
>> + * Note there's window between ftrace_shutdown and ftrace_startup calls
>> + * where there will be no callbacks called.
>> + *
>> + * Returns: zero on success. Non zero on error, which includes:
>> + *  -EINVAL - The @ops object was not properly registered.
>> + */
>> +int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>> +{
>> +	int err;
>> +
>> +	if (check_direct_multi(ops))
>> +		return -EINVAL;
>> +	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&direct_mutex);
>> +	err = __modify_ftrace_direct_multi(ops, addr);
>> 	mutex_unlock(&direct_mutex);
>> 	return err;
>> }
> 
> I would personally do:
> 
> int __modify_ftrace_direct_multi(struct ftrace_ops *ops,
> 			unsigned long addr, bool lock)
> {
> 	int err;
> 
> 	if (check_direct_multi(ops))
> 		return -EINVAL;
> 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
> 		return -EINVAL;
> 
> 	if (lock)
> 		mutex_lock(&direct_mutex);
> 
> 	err = __modify_ftrace_direct_multi(ops, addr);
> 
> 	if (lock)
> 		mutex_unlock(&direct_mutex);

The "if (lock) lock" pattern bothers me a little. But I agrees this is 
a matter of taste. If other folks prefers this way, I will make the 
change. 

Thanks,
Song

> 
> 	return err;
> }
> 
> int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
> {
> 	__modify_ftrace_direct_multi(ops, addr, true);
> }
> 
> int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr)
> {
> 	__modify_ftrace_direct_multi(ops, addr, false);
> }
> 
> To avoid duplication of the checks. But it is a matter of taste.
> 
> Best Regards,
> Petr

