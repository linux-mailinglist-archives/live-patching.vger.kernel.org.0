Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3742F4BE670
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 19:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355750AbiBULRM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 06:17:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356204AbiBULP5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 06:15:57 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90045.outbound.protection.outlook.com [40.107.9.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7651C65D2;
        Mon, 21 Feb 2022 02:57:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQBuYB0BBBvbvSFON8K6zAWdFEmE3lGHS9ZzdSqsT/ay76I7ucGp3oyVtbKtlnWZPvkwvpWYsGmyQsP/OtiRejRkiV6/gvFwXCtcRei9dG3UsfgFXYgFaYjxm7SraWHD+0ghfQn7EG0oPgP9UtkqS/dnIz6OeT+0yuPEjdgl4/ddbjToX1NmaohuhpxhzLcd3t70+GpE9pAZpYxnY71IOSTxLlNBgbT674D6ZN+//7bbvwmV4E9AZObQ6HZJEdRuiuXGMCZjRiHP0o+TWXMp4NVf2trkmi07eceSYTyFcJcx78ZEoEsPMAlq+MpECtDRRFHIC91UKMmQqhkDbS9R1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mT+nMQSLBUVfpEZBUGY5+i07IH/pd8VMllHSx3LOS6E=;
 b=BUAPVL1CbVaPzPRIGS1LiTrgN92FrPdS+8KEBEfCfm82JdLVHGPHqJQZRuCdY1r0r3KW5QMiMja4U43qlzoXc+tPNlfKcLF3+sWevmJ6nbWoZQwfASWJdZ8dKUgkaIjw6O2DOx4A//EPmtw5Nu6srZSMgpwtlJOjA8fAzZyYqljuLe/5qc82uR7DOl/pCesyfs/ZtJWNC5nnv6PN4fzcV7ugB+CF3poYQV8F9HZn7Ilb55fZr/xSIZhi7k1dZtiZNaIGsMREOV66dOVHAspnmJauSyFOIzuxfpoFJeN/FlS/IbNjXSDxy5YoxJtHyQjDOXwg90qjWcr85KcUL1F6Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB1599.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 10:57:29 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 10:57:29 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
CC:     "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v6 05/13] module: Move latched RB-tree support to a
 separate file
Thread-Topic: [PATCH v6 05/13] module: Move latched RB-tree support to a
 separate file
Thread-Index: AQHYJQ4Li2kl3i7sqEmfjQGnKmZO06yd2YUA
Date:   Mon, 21 Feb 2022 10:57:29 +0000
Message-ID: <97c7654d-bb44-8539-1646-1cfdaddeee7e@csgroup.eu>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-6-atomlin@redhat.com>
In-Reply-To: <20220218212511.887059-6-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e25b55d3-5772-45dc-9134-08d9f528f410
x-ms-traffictypediagnostic: PR1P264MB1599:EE_
x-microsoft-antispam-prvs: <PR1P264MB15995A7B52E6A8D3BB1914A5ED3A9@PR1P264MB1599.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fcpHH7nlUdTASV0UMt26UzokY+DuH20Q1+3S03IpMxiQId2ajr7N7AxHsaWbT69f2MYe3uqrZgx+W6VGjZery/O4yAWOoNdPSTAuGISfWktY7PzGwK2judiPDwHWE2Z/ODN9lE1E5/eH+IJjklNMzJTmn6lhetCbDUjG4xBS+tpNuy9lKyATZBspZyxhpX6tgCdNCN4rbhTNBSTXRFFOUcwclQfuNBt+zRvnJtQ6tnXCGXaqKRzGzXGIz84QB5DJPC7IHByawbUZHrCXl4TOGTRagH25PVuwU/+OKa2Tn6wQ04REDCCg/L9mz2vkuyyEsWNnMuGaZPNy4De6WnluZ0griMEcUcn5KbWJRiqLf6LKGY/ecSGURhemOjQhagf8I6ZDRa0FqBxLGhEZX5EHpN5gE4Q3W67NZPEVVzr8RZpe2PJvXj8TQ9o2zQD4/Dy/XSaHdowUAnYYBk8VCnBMRSYijP3MtI/yFnLU/zfUwtAx806De1mhcn0sh32sf1KN0BbMb4tcKwCgCmmbd3eGwmn59L2B7nsu7IXTxYoLxtM19wAVkxfve+DGpoeuQtUxnXBSLRVx3FDWjIJPzEesSxNFIaYWrCYxaHxuROKJxJd7pL7ksQLsgQWXmJoIsUeR0o5BVH4iKBxPwH0WSosn9Gb/CwHqAPUMYmLKKA5+x1nEtcTwhmmPdm6+C6GrS73b/TDynawyptllH6UgaxjbF8eVdi2wdPPVCokwP7Gd3VeV9QAO9KQm3Ky+ukPaS44cpAQuGPa0u1eMu1HhcVi9ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(83380400001)(2906002)(54906003)(36756003)(66574015)(6512007)(316002)(44832011)(26005)(508600001)(38100700002)(71200400001)(7416002)(6486002)(186003)(31686004)(8936002)(38070700005)(91956017)(8676002)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(122000001)(31696002)(5660300002)(76116006)(6506007)(2616005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlI0YVl2aXQrWUtTbDRmZjhLREdOWjJZR1VDcEtwZmMrUklrNFJPUWZLS1JO?=
 =?utf-8?B?dEs2c21KemkycFM5cHBZSzJtd3d4bCs2NTBJU2YzOXh3cDZNRFY5R3dhci80?=
 =?utf-8?B?TFlYc2xtdHZGaTFSSlFrYUhJbkpMZmw2WFZFZE8zSEJObnI1Y000OGEwbEJU?=
 =?utf-8?B?WDloYk5KS2JJTkYvVGF5TTllTFd6STJVNlhEckNmbjA5NGJDVGpoZWRKdTJJ?=
 =?utf-8?B?eG9OR1d6M01icFc5UE9teDhGWkVBc2Rjc2hJWGJyOHlpVnFzVlMxWXlBeVVw?=
 =?utf-8?B?cVNzT2NodnFXWmVRWEhjQWhzNEhmVHdXS2JYWVBDbWRsYXpHSG01cmNHZXUw?=
 =?utf-8?B?OVd0N3REK2NkOE96akoyV1JtZGlxWDVka1cwWnQ5aW5zLzFJL0pTam9zbGVP?=
 =?utf-8?B?Q3lrQzdoWEZhbTZNaWt5Smx0YlFrTUUva0VpTkxSNFVMTll6Z3lTdFp1ZnAz?=
 =?utf-8?B?bDlpVm9KWEg2THJYa0ZRMDh0VzVkNEkzdnlUZStxcDNhaEZWbExoWUsvK1Nk?=
 =?utf-8?B?OXFuZ05rVVlTcSt4c0pSZU9GWWdqVklKQnFtZ0NIY0pZd1hnN29qZnBlcDhi?=
 =?utf-8?B?YTZMZ25ubXRFdXdEeFhBRDRwb2dCajI3TW9CQkFhV3VlVzAwWmw2OC9UTncw?=
 =?utf-8?B?OU9GWENyWi80bG5Scjg2UGlCazFFWnE3UW40WWRQNmpGMUFOcHBTUllTbTVI?=
 =?utf-8?B?Sk8rSDV3aTEwbnE2TERFeU1BU1BHVnpXK2w5M0hIdDZ0NElwRlpTUGtkZTlz?=
 =?utf-8?B?RmtpcW5nZllINTFoU2lIYWJiM1lTb29lZDFuZkI1N2tRZi9aSnIvRUVHR0dv?=
 =?utf-8?B?YkdJK3RMUjJyaEYrdWM0UzE2Y0tGM254K0hkMmRRRndmb0w4NUNWVVM4SnNC?=
 =?utf-8?B?ODhmZU5Jd3dlNHBpWkovUVJqVVVjNjRUTHJSMkI4ODJZbVhXV2xVdDc2MDR3?=
 =?utf-8?B?d2VJaDlsVWZxMFpXVGJpSFBKaWQxZ1V4S2tkK3JvY0JXU3Z1QVNTT0JqQ3Bm?=
 =?utf-8?B?c01pRmdSblE0Ui9JSlQzNDlINTROQlBhdGl3bmtFaldsVGEwT28xVEhKeFFI?=
 =?utf-8?B?Vmc4NlRiZkdqK3M3Tm9rNExuMXh0RFNlZDY2aDhWYVMvMW1wK0p2SmJiQ3Qx?=
 =?utf-8?B?anRsaWFpNGh5aTZvLzVSbTZiREZLeFBWV0krbHV6eGMxVUFhU21uZ2NyeGxP?=
 =?utf-8?B?Vjl5WjFKQXhPaUlsd2RFQmhsOWRYOW1zWFpCUlVkY21RTExtNjl1M2c4bXc4?=
 =?utf-8?B?dTlvRFpNTmZUV1owU0RYa2NnK1czRkNOZG1keFZHejkraVZVODVHVzBwSWhw?=
 =?utf-8?B?eFFrdzFiL2thZ0plOVRMWlhmS016NGVzbGo0NnZWSFJaRlVkRCtuVll3Z080?=
 =?utf-8?B?aDNKTTJWeWdzaUw5THcwWHArcS90STVFVTMxMHFSVnlZeTgvNmhPcUZFYko4?=
 =?utf-8?B?d3pIZ0k2SHF2UW15NjlOU3ROdVh4dHZwNzl3aVRIakxqNWlySmgramRVbW1O?=
 =?utf-8?B?U08zVmppVDVQbEorSDZQUi9BalRMaGdkb2tTQm5jZ2FtMFpnei9QNWtMa1pV?=
 =?utf-8?B?TkJZMG9QUlpBNmpjVDlFVkJRS09FQ2R0dDQ5cGZsVkJyL2Z0cG1FTndKY1cv?=
 =?utf-8?B?aERSWjJMdnlwQUErMEtwSW1DbWtSekxacnMwdmtJTWZ1aXlPNlllTGtqM2dj?=
 =?utf-8?B?Vkx3Tk9UT2VydXYzNGhycEF6Z3k0ME1wTUZwSWRYY0NHVXZqRDBkZFJLVzI5?=
 =?utf-8?B?c29qcXd2V0JSQlJHcDJwM25ORlJoVWErWXpaSFhwbE83RWtRWDRrdG92N0dr?=
 =?utf-8?B?b1FyU1N2blh6TnhzYWVBYjlQMmp2YUVhTEU0SDZGZktzU1hhQ1JTMlp1VW5R?=
 =?utf-8?B?K1I3Rm1lUDhmcXpreCtIakliR1ZTUkZPYUE3VElnNWFaTFR5eTFabFZ5T1NQ?=
 =?utf-8?B?UGpaTWU4S3ZqSGRKdnVTVlYzRko1dmROQ0NVcWQxU3d1cERSQlphKzF2UkRC?=
 =?utf-8?B?TnNycTIrWXB1dU9yRHhocHhjbDFFdlVJSVRMazNVM2l6ai9mVjFBL0tCL0tY?=
 =?utf-8?B?aGxUek1zMUxJNTJZeGRaOXRmblAyMy9jVzBQRHBLOGVxTjVOSFdsUy9QdWFL?=
 =?utf-8?B?WlYxT1F6MUJPNGNmV3Z4cVVpUlFENnBPelRQblBQbk12c2NKaVFUQmw2U04x?=
 =?utf-8?B?VVZJbUhpUzg3UWxpN0JrRVB6TENDVkFiQlQ1NmJPcnZtelgyQ1p3bEdsQnY1?=
 =?utf-8?Q?S2Ut3PiXVjqMe6blzhdAiJ/OqNj1h8bHUWpUaPyFfA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A722A2C2FD93A44291E7F54471963C67@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e25b55d3-5772-45dc-9134-08d9f528f410
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 10:57:29.0921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZEUJEpQBcd8kn8tAFjizSlA8Xc/YCkkTGMTynVpVH3XJWsaAVYFtXNIPPOKDVSaLWgNMpIxtPWQDW3kVC2UZqh4ABXeiVB+D+fze/rvp7Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB1599
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE4LzAyLzIwMjIgw6AgMjI6MjUsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMgbW9kdWxlIGxh
dGNoZWQgUkItdHJlZSBzdXBwb3J0DQo+IChlLmcuIHNlZSBfX21vZHVsZV9hZGRyZXNzKCkpIGZy
b20gY29yZSBtb2R1bGUgY29kZQ0KPiBpbnRvIGtlcm5lbC9tb2R1bGUvdHJlZV9sb29rdXAuYy4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIFRvbWxpbiA8YXRvbWxpbkByZWRoYXQuY29tPg0K
PiAtLS0NCj4gICBrZXJuZWwvbW9kdWxlL01ha2VmaWxlICAgICAgfCAgIDMgKw0KPiAgIGtlcm5l
bC9tb2R1bGUvaW50ZXJuYWwuaCAgICB8ICAzMyArKysrKysrKysNCj4gICBrZXJuZWwvbW9kdWxl
L21haW4uYyAgICAgICAgfCAxMzAgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQo+ICAga2VybmVsL21vZHVsZS90cmVlX2xvb2t1cC5jIHwgMTA5ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgMTQ5IGluc2VydGlvbnMoKyksIDEy
NiBkZWxldGlvbnMoLSkNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS90cmVl
X2xvb2t1cC5jDQoNCg0KICAgQ0MgICAgICBrZXJuZWwvbW9kdWxlL21haW4ubw0Ka2VybmVsL21v
ZHVsZS9tYWluLmM6MzcyMzo2OiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yIA0K
J21vZHVsZV9sYXlvdXQnIFstV21pc3NpbmctcHJvdG90eXBlc10NCiAgMzcyMyB8IHZvaWQgbW9k
dWxlX2xheW91dChzdHJ1Y3QgbW9kdWxlICptb2QsDQogICAgICAgfCAgICAgIF5+fn5+fn5+fn5+
fn4NCiAgIENDICAgICAga2VybmVsL21vZHVsZS9zdHJpY3Rfcnd4Lm8NCkluIGZpbGUgaW5jbHVk
ZWQgZnJvbSBrZXJuZWwvbW9kdWxlL3N0cmljdF9yd3guYzoxMjoNCmtlcm5lbC9tb2R1bGUvaW50
ZXJuYWwuaDoxNDA6MTM6IHdhcm5pbmc6ICdtb2RfdHJlZV9yZW1vdmUnIGRlZmluZWQgYnV0IA0K
bm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0KICAgMTQwIHwgc3RhdGljIHZvaWQgbW9kX3Ry
ZWVfcmVtb3ZlKHN0cnVjdCBtb2R1bGUgKm1vZCkgeyB9DQogICAgICAgfCAgICAgICAgICAgICBe
fn5+fn5+fn5+fn5+fn4NCmtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaDoxMzk6MTM6IHdhcm5pbmc6
ICdtb2RfdHJlZV9yZW1vdmVfaW5pdCcgZGVmaW5lZCANCmJ1dCBub3QgdXNlZCBbLVd1bnVzZWQt
ZnVuY3Rpb25dDQogICAxMzkgfCBzdGF0aWMgdm9pZCBtb2RfdHJlZV9yZW1vdmVfaW5pdChzdHJ1
Y3QgbW9kdWxlICptb2QpIHsgfQ0KICAgICAgIHwgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+
fn5+fn4NCmtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaDoxMzg6MTM6IHdhcm5pbmc6ICdtb2RfdHJl
ZV9pbnNlcnQnIGRlZmluZWQgYnV0IA0Kbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0KICAg
MTM4IHwgc3RhdGljIHZvaWQgbW9kX3RyZWVfaW5zZXJ0KHN0cnVjdCBtb2R1bGUgKm1vZCkgeyB9
DQogICAgICAgfCAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCiAgIENDICAgICAga2VybmVs
L21vZHVsZS9rYWxsc3ltcy5vDQpJbiBmaWxlIGluY2x1ZGVkIGZyb20ga2VybmVsL21vZHVsZS9r
YWxsc3ltcy5jOjEyOg0Ka2VybmVsL21vZHVsZS9pbnRlcm5hbC5oOjE0MDoxMzogd2FybmluZzog
J21vZF90cmVlX3JlbW92ZScgZGVmaW5lZCBidXQgDQpub3QgdXNlZCBbLVd1bnVzZWQtZnVuY3Rp
b25dDQogICAxNDAgfCBzdGF0aWMgdm9pZCBtb2RfdHJlZV9yZW1vdmUoc3RydWN0IG1vZHVsZSAq
bW9kKSB7IH0NCiAgICAgICB8ICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fg0Ka2VybmVsL21v
ZHVsZS9pbnRlcm5hbC5oOjEzOToxMzogd2FybmluZzogJ21vZF90cmVlX3JlbW92ZV9pbml0JyBk
ZWZpbmVkIA0KYnV0IG5vdCB1c2VkIFstV3VudXNlZC1mdW5jdGlvbl0NCiAgIDEzOSB8IHN0YXRp
YyB2b2lkIG1vZF90cmVlX3JlbW92ZV9pbml0KHN0cnVjdCBtb2R1bGUgKm1vZCkgeyB9DQogICAg
ICAgfCAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fg0Ka2VybmVsL21vZHVsZS9pbnRl
cm5hbC5oOjEzODoxMzogd2FybmluZzogJ21vZF90cmVlX2luc2VydCcgZGVmaW5lZCBidXQgDQpu
b3QgdXNlZCBbLVd1bnVzZWQtZnVuY3Rpb25dDQogICAxMzggfCBzdGF0aWMgdm9pZCBtb2RfdHJl
ZV9pbnNlcnQoc3RydWN0IG1vZHVsZSAqbW9kKSB7IH0NCiAgICAgICB8ICAgICAgICAgICAgIF5+
fn5+fn5+fn5+fn5+fg0KICAgQ0MgICAgICBrZXJuZWwvbW9kdWxlL3Byb2Nmcy5vDQpJbiBmaWxl
IGluY2x1ZGVkIGZyb20ga2VybmVsL21vZHVsZS9wcm9jZnMuYzoxMzoNCmtlcm5lbC9tb2R1bGUv
aW50ZXJuYWwuaDoxNDA6MTM6IHdhcm5pbmc6ICdtb2RfdHJlZV9yZW1vdmUnIGRlZmluZWQgYnV0
IA0Kbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0KICAgMTQwIHwgc3RhdGljIHZvaWQgbW9k
X3RyZWVfcmVtb3ZlKHN0cnVjdCBtb2R1bGUgKm1vZCkgeyB9DQogICAgICAgfCAgICAgICAgICAg
ICBefn5+fn5+fn5+fn5+fn4NCmtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaDoxMzk6MTM6IHdhcm5p
bmc6ICdtb2RfdHJlZV9yZW1vdmVfaW5pdCcgZGVmaW5lZCANCmJ1dCBub3QgdXNlZCBbLVd1bnVz
ZWQtZnVuY3Rpb25dDQogICAxMzkgfCBzdGF0aWMgdm9pZCBtb2RfdHJlZV9yZW1vdmVfaW5pdChz
dHJ1Y3QgbW9kdWxlICptb2QpIHsgfQ0KICAgICAgIHwgICAgICAgICAgICAgXn5+fn5+fn5+fn5+
fn5+fn5+fn4NCmtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaDoxMzg6MTM6IHdhcm5pbmc6ICdtb2Rf
dHJlZV9pbnNlcnQnIGRlZmluZWQgYnV0IA0Kbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0K
ICAgMTM4IHwgc3RhdGljIHZvaWQgbW9kX3RyZWVfaW5zZXJ0KHN0cnVjdCBtb2R1bGUgKm1vZCkg
eyB9DQogICAgICAgfCAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCg0KDQpDaHJpc3RvcGhl
