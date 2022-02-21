Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB444BE4A2
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355898AbiBULOS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 06:14:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355824AbiBULNu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 06:13:50 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120081.outbound.protection.outlook.com [40.107.12.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F26810B;
        Mon, 21 Feb 2022 02:49:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/yvbtc3zinPP29S26gscf9AP/lB51t8hJWKnZZMwxgsBantbQsdBPzw270XfwH10RXH6QmbQN+FLX2bpCAq2sZ84rwacot2b7AyWTu7jia49Ba+MbfpL89x8swRwjWSZGvWm9Oubirp84DJt9q4gvN5qLzVYikmq/UeOiSjCdogG23abKzUt5tJ9la17BAq/w4bT0rUk+3ElXOZ4kuJuU+R5rd70s9TYQkjSBRM2BRkEcEwKhO+zIO3+Jx4p/15ws29dTe1mfFbdYAVSnc4gzWTu+yHlyCzE2PAfCSOvxH/7NloIQanzmdijlkoda3WGwu755oz2O69PQSCfl3/VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aY6ojD+vRbvRUNag3UNgNSM380l+r8xl4NuEf44w4Nk=;
 b=Sds4VyTnLsvaguCe5+8povgV0wFVpAbJwpdgtysxM6rt3eyM60/+T5gX3w/4cTjKpn+XCn7TYaEVrLtSpvpiR/Ojxidc8njy8NPf7f+B1gAUUuEzS96qV/yyBTae8nhS+AFJRlovmFUA0te8mGUxojCRWN9QrjSez38syjE7Ts7b9u6u+DwdUlNTTr31iFbvuNZnHgCzu2Vdfo2SrhcnZeSTwTfvt38NjdNnpmMCfQKPlCi/rzQeFJeVFz0IK6nmapcQ/1dXQAxa0qoOe+WvRUiEv9dHxnSXnTdHSWVUoN6QoTn14FgdaQHWoonj1CUX40YTK7cp0DWw+6lME1OmTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR2P264MB0884.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 10:49:43 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 10:49:43 +0000
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
Subject: Re: [PATCH v6 09/13] module: Move kallsyms support into a separate
 file
Thread-Topic: [PATCH v6 09/13] module: Move kallsyms support into a separate
 file
Thread-Index: AQHYJQ4QuMcWnRXchEuo5UQTg6cwKqyd11uA
Date:   Mon, 21 Feb 2022 10:49:43 +0000
Message-ID: <40f31a7b-2d06-8316-1a88-128ba72518a5@csgroup.eu>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-10-atomlin@redhat.com>
In-Reply-To: <20220218212511.887059-10-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f264bd06-df82-4ffb-58c4-08d9f527de8d
x-ms-traffictypediagnostic: MR2P264MB0884:EE_
x-microsoft-antispam-prvs: <MR2P264MB08841C8724734FF20B378BF7ED3A9@MR2P264MB0884.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGwsvlThYtkOHwyETAuZwuOxbdokfwQt4r7IQx66TCeFRS/nlRS1z8JTVelA/TfhbNjWOzXjQG4ghnNSBv8QRc5bbgGbiK6jiIwygfmo46T5LqgonncaCvJ6C7EMaoAYoFW7BmzLaOBVMVIE+dNZO6z2kHqptF2W303XEEtDPcfIqVYH2ppAD7smyBzfcOybWHgv2TSJZTgLH/1OazgoBouymJHrb8OfRkK1hJTh+DT9AkkLiiZ/1W9TDgd8VLUYHDtHPwHgdyFclEp3lwrAKzPZUscSFfrUOCC+NzCWzvJvsoUm1iYoIu5JV7xtiEbUp5WszSxUHpvLUSDkVMsz6YTihJr/ce5YJsupoK19wMVCrjHnta7jQgViGH+YIG9OlW2wqI1NNx3aggKoNWIMK4N1b88wuZnRK2JQfUUYqsSqqjlpZch9vgi6lG9YCzwb1i6Kz1jGJGj4JNbiAT7+vBKvuw5vB6GkVUdGYb2xPD+0LkmCAB59FPWeVTDMV8DBuqhNY3eY+LwOlS9epxyZDrwOrjBTtCKES8crwgT1sTQfw71sOtL9rZIPHE5ArtoqO6ntOOWY/RCdbdUvy0Ux5Kwa22yRyOJZzrb/Vwb8UW1uVoIgw4JGmWlM24fXLkApwIuJLFWYTIOAqddYgAvPMogyBornIO1brtzh1SgpwOXCCG8OpE1QRPqVicTz0uv6T09tpAL3gXpEyD1UhvkjJIFcUFTsvyqKMzUc+WVD8/linolDV/OlRNMmtGxl+A2tJX+M9JuWy0vs79rc9MK1GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(91956017)(66446008)(36756003)(2906002)(54906003)(110136005)(76116006)(66946007)(44832011)(66476007)(66556008)(64756008)(5660300002)(4744005)(8676002)(508600001)(316002)(4326008)(7416002)(31686004)(8936002)(71200400001)(38100700002)(6512007)(6506007)(2616005)(186003)(26005)(38070700005)(83380400001)(122000001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UW5QaXpZb0QrZnRhN0grRWlzcmhHakg2alpBTkFXWnBOZmd6OU1send5NEd5?=
 =?utf-8?B?SmhYNENOWmovVnZkV0RpSGFoNG5zUXorV3N5OEduYlNOdmdobG8zN0dqU0pU?=
 =?utf-8?B?UjVzSGlKbGtTSGR6NENjZ1VZV3JDV0dBOVJkZndVY2V4RlVYS05LMUdRSDJy?=
 =?utf-8?B?ZjEyNlpzZTA1bEQ5cmtTMnJuRERFYUxad0NlY2JKWlc1MDlqRU0wRk5yeGQx?=
 =?utf-8?B?MncwRkJVZDZPZnNmeHNmTzg3SktkekVrSGZscmNHdVJqQ1lndzdxV2tJaXls?=
 =?utf-8?B?SHVXMnFHL3JDR0xIb0pXMFNFU0NqN3E2YlQ0YWppTWxmT29Vd1ZwYXEybTBs?=
 =?utf-8?B?T0NhbE15bXpYSEdtOGtkaU5nMHBMRlBXNmxRU2lWZWs1ajhrY0RjaS96L2w5?=
 =?utf-8?B?c1JRc25rL0Evenh2cVpQNnJYUXpwUWdpaHRKVGFnbStsa3dmNlBnQmV3S1lr?=
 =?utf-8?B?aHlCZm93dnpmb3F3a1NRZzVyaGpGeklaUndIaklxS1poU1RZYUd4SVlSUmpO?=
 =?utf-8?B?cHZXQVhsbTQySUNkTjRUSU9yN3NQSWNJdlZ0UTA5eWRnV2xORXRERkJkcnoz?=
 =?utf-8?B?cWxoTjArWkd2d002bG16Mm9JdXAxWjloQ0pqcHExS29vd3dYRVpoaHY2NGkx?=
 =?utf-8?B?bjk0YkRhbGFSQnlQT3ZHbE9jTVB5dlJxSmRocmI2L0xxeEw3d3hVbEZULzBU?=
 =?utf-8?B?V3FaQmNPRGZQSHZHSk9ocW1Bem5sNy9pVjh5TjltYlR1WFFUKzZpWmJlRTJw?=
 =?utf-8?B?TWJZaGVhczZoYVMvblJWbGZNSFFYOGZtQldLcW9kTkdWczMxNkdCRkpIaklw?=
 =?utf-8?B?R3RUSDk2SFdvYW95aVJ6RmJEa0hoV3dwQit3cFJ6Yk1pdkJXOExDWlc5cnlM?=
 =?utf-8?B?aExrVGZ4TEE1ZVhYOWQxWnRzU24zdVdoWFBPRHAzNkJNby9ITXhYQ3V4S3R4?=
 =?utf-8?B?Q29zV3RldjVjelBMV0U1K2UrQng4SGhvOVhIWVhyVzFaT1RSemZxd2cvZXdZ?=
 =?utf-8?B?bWJPNDZ6Y1JLNlZMV2t3a2E5WjV6RnF4MTE4Z1MyeHdXTGplenJCd0Nod2RC?=
 =?utf-8?B?WkswYmhzeHRLZGxGQzBsckpwTGhFb1dRd1lDQnJZSWViMmNoalFFbEFiMmFm?=
 =?utf-8?B?dmlHL1JFRVJKcy9IVVg4VnU3UEtETmkrdzZFQkdHM0xwR0hoSW5HL2VBeEFK?=
 =?utf-8?B?ZWJVbHZjTVBwaW15RG1WOXhnNXZsTkhzRk1uS0c5NGtZYWN6L1JwNktMK2tE?=
 =?utf-8?B?bDdnN1BFVVFaa2RwRjBaTDVrL3VTRVF0eGZ1aUVDbWIrdDIyVGdKSFVEb1Mw?=
 =?utf-8?B?ZzI3M3BpMXdtREdiaEdXNjhGU0tGa2F5MEU5WHNBTDEwQ3dBZDArbzFLMjJy?=
 =?utf-8?B?RjVHVFFxb0VnbHpSMkxiRlR0ZFlFSHoxTHE3THErZzdJRjFYa0hPZ0hURE5T?=
 =?utf-8?B?d2JzZWxySHFEYjg3ejlQT3FBN2hhSnVua3ZtOG1BYjlUWHpTeXhnc1d1SlFJ?=
 =?utf-8?B?ZWtPaXBrSldORzE0SkhnOVJKV3hzZFRkQzJrbFhUcUNZWkVjNWJudjVHYm56?=
 =?utf-8?B?dUF1QUJ5Y1k4dUVrMU1RbytnemdMejBLUGY0RWh2dDNIaWIrTmp0VDVhb3FO?=
 =?utf-8?B?Y0ZFOXFGU0c4eExvUmdvNjhPbm53QkRuNjhiem5jUFBTZVl2R1drYlpRSXJy?=
 =?utf-8?B?ZlhCSUVTS080NHNEdVJ5TTF6RkFseFlkOHV6UVMrN0U2SEJGaWJ1cGVsWXhj?=
 =?utf-8?B?Yk9ocEJqclJGUkhvNVVpa3Jhd3d2TjA4RVlQUjhyWmptY2ZVWTZMTHlFSkVo?=
 =?utf-8?B?dko2NHh3aWpuUzZxREprelVVTGJkdmNzU0ZCajZuRmVWZVpmQ2NFcFJiSlo3?=
 =?utf-8?B?M0JTUEpYdXg5WUFVanp0NGt0TjRxTVYvY2VjbGNMUXVpb0VqbHgvRnl3eEMz?=
 =?utf-8?B?R0x1WndoMDhhWmIzRE1VM0paNXd4MWNDZUpDRE1aRzRRRGR6ZnZlL1BiNVlM?=
 =?utf-8?B?KzNoVXJKbkprVGVKNk5uK3IvRjNMc09XVW1uUzJ5VmF1WHEzOFEyM3hzS1I2?=
 =?utf-8?B?QjhaRFJaQmFyb2F6azlIK2htVHhmTVRkWFRJOEQrWThFTjVrSitTbmxoKzFl?=
 =?utf-8?B?NWF2VFBMMnlhQnFEdnhGQW0xVDg1RUw0K3BiYWl1QjFWa0l2Y1BhTVExUWJ2?=
 =?utf-8?B?N3BKS3krdGNTNkkxcE5zQTVPLzl6QXlrTnZxdzVvaVo3Z0FBWnlmMDRKK1Mr?=
 =?utf-8?Q?yp/VspctCu5NWNsPQiVAuSKTHgzYwETg63cm0YLqY0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <478AAFBC2F761A4EA6A8CB0690936EF9@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f264bd06-df82-4ffb-58c4-08d9f527de8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 10:49:43.5189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0b5HIUT+w6rTT5UgiiV1R1+iYhoJSYd2YFQ/JwbAZqrzwjl+dWYnZq1qKmjKrsggSeQKZndXX2gvSz5oNf9O24HDab0dyf0V/5OoXH3aVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0884
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,WEIRD_PORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE4LzAyLzIwMjIgw6AgMjI6MjUsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMga2FsbHN5bXMg
Y29kZSBvdXQgb2YgY29yZSBtb2R1bGUNCj4gY29kZSBrZXJuZWwvbW9kdWxlL2thbGxzeW1zLmMN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIFRvbWxpbiA8YXRvbWxpbkByZWRoYXQuY29tPg0K
PiAtLS0NCj4gICBrZXJuZWwvbW9kdWxlL01ha2VmaWxlICAgfCAgIDEgKw0KPiAgIGtlcm5lbC9t
b2R1bGUvaW50ZXJuYWwuaCB8ICAzMiArKysNCj4gICBrZXJuZWwvbW9kdWxlL2thbGxzeW1zLmMg
fCA1MDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAga2VybmVsL21v
ZHVsZS9tYWluLmMgICAgIHwgNTMxICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgNTQxIGluc2VydGlvbnMoKyksIDUyNSBkZWxldGlv
bnMoLSkNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9rYWxsc3ltcy5jDQo+
IA0KDQogICBDQyAgICAgIGtlcm5lbC9tb2R1bGUvbWFpbi5vDQprZXJuZWwvbW9kdWxlL21haW4u
YzogSW4gZnVuY3Rpb24gJ2xvYWRfbW9kdWxlJzoNCmtlcm5lbC9tb2R1bGUvbWFpbi5jOjMzNzk6
OTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIA0KJ2luaXRfYnVpbGRf
aWQnIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KICAzMzc5IHwgICAg
ICAgICBpbml0X2J1aWxkX2lkKG1vZCwgaW5mbyk7DQogICAgICAgfCAgICAgICAgIF5+fn5+fn5+
fn5+fn4NCmNjMTogc29tZSB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycw0KbWFrZVsy
XTogKioqIFtzY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjI4OCA6IGtlcm5lbC9tb2R1bGUvbWFpbi5v
XSBFcnJldXIgMQ0KDQpDaHJpc3RvcGhl
