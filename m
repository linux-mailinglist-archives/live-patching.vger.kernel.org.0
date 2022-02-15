Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E104B710B
	for <lists+live-patching@lfdr.de>; Tue, 15 Feb 2022 17:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbiBOPLh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Feb 2022 10:11:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbiBOPLb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Feb 2022 10:11:31 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90073.outbound.protection.outlook.com [40.107.9.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F6810874D;
        Tue, 15 Feb 2022 07:11:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQZQjKGzyO12R2ITURJzcVGTQwB0JO9gdgNxu52FH7Z/2D1qbJTcVrojn9qGogP+qrNDFIh7888zYS1xPI3WHL77bcDFE0DrVv75zmL2KDYuWeljPcaJHKJCDqV353GFU2CNebT/5SmODfCn3yNzFU5uMOw30+Yq6Mcg94/A/9dzrqins1Jp+s+agHe/54mYg1qTDiVEpnmyVd9Jc5LBbwMBNDijD/JL8H1KqGBk6HNtxGFglQonQ6rgTkpcuSR8kv/Qonl1mUM93Mw5JRTuTgXa6YypAccLlB6SCMkGaow+E1bir1XvlYTQ07hurYyDrzAbgX6GZu2ESMDFy/DyBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VjnTJVi2NjS2YZASzZG7RSpITG+/tYsMhHeGaEwTfs=;
 b=KGDlPVuZ6RAmkt8/HCUfaU/zcBvMaudzmwk+Pa/CisOv8U81wkfScKRarPvFig3ESLqwOUcTYzPKjjCfl8jSogpCMgh4FuebhT+VszYs/CUofJHNfULqITBatJqqsVCSZ6rCsFoKEaQF6ifxafF99dNHjPMQ28FTQ7wNk8U+fmSDbutfdlvlAu+gSmc/D4ftR8437rvoc2yM6sCpxmLPF423jNyKYZ/60sXjJ2OxjevGWHQtjxW5iRleftxPapU/SL78NL9+BTmmtv/kCknoMzr1wjLaMV4KPehwSri/csaRAZU1F2AiagumM0W5UJExx03FrO2v0wHTUX0amLJz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB3115.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:30::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 15:11:18 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 15:11:18 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@atomlin.com>
CC:     Aaron Tomlin <atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v5 13/13] module: Move version support into a separate
 file
Thread-Topic: [PATCH v5 13/13] module: Move version support into a separate
 file
Thread-Index: AQHYHdgTxacpqtiy80KvpiF8QXDq16yM2SEAgATzOQCAAAdHgIAC68CAgAABfoA=
Date:   Tue, 15 Feb 2022 15:11:17 +0000
Message-ID: <954fcff8-ddf2-f2bc-05ce-6a7f9d668ae2@csgroup.eu>
References: <20220209171118.3269581-1-atomlin@redhat.com>
 <20220209171118.3269581-3-atomlin@redhat.com>
 <14a1678f-0c56-1237-c5c7-4ca1bac4b42a@csgroup.eu>
 <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
 <d3d87e3e-e13f-252a-1c06-f18a78af5d98@csgroup.eu>
 <20220215150557.g7mvx47ibhjgweyo@ava.usersys.com>
In-Reply-To: <20220215150557.g7mvx47ibhjgweyo@ava.usersys.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4df30192-1da0-447f-c82d-08d9f0956aad
x-ms-traffictypediagnostic: MRZP264MB3115:EE_
x-microsoft-antispam-prvs: <MRZP264MB311596CE98B4139FBBE27C8BED349@MRZP264MB3115.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zVjti0qOAiqqCDVNLiHNZ4wv5KWGXiVRIHvL9/3GB2e8amV1FfQvNb5wxhaT19Uu/QefGlfSFyLOpx7VvHZqnQ8AL+CkPW5fEh7EreT8X8L23hqRF+ZpJQVjd0DIe6JfGHDsy5joujbA9Nr0nknciPWM0D0dNHMzizs390vJl/dLmiVo1bY34agybFbWd/tV2YszgRDbDlsPvBErSZ8hfsVT5GlG6Q3h2+0O/BKvpqyVsIBRAl3btIKIuGDrIT7ANwjoVYitiHAaReIOBZocX/jz9uo+q04/khQpPST8rZZ9ikFkg3EzJ0ub1MS2I5FlABZTGz4253MJ45jEIXu7NkC26lDMlvkCd2xDIl/TwwQrF7p5kR0MXpBZFvml9OI2iE1O9ONafCxkynsFe5bv/PFDqpnIBT2AEzkkJ1neX/4O6XClJskBdKB4jTkdP0BghWfpfNUi6L6jdw8Q3wvWiOvPMQBisJFze5vl9SZzVjmpvWl48vhDhFz9+CCx6VwQOf8UyzgUuhf96X9zk8w4Zc+Nr6nYpTD7TNEMCxjXeyUAGEKX3C+MUs6rWUU9z014SmilWX0BnDTkE/4mJQe2wDULDXM1tmD29BACCtQJRaojE/HLiBizwxiWIZgHwCyKqRBRB5Sv+da5fGwDeRUrB3BztnlQe7PA/I2gHa4aNU90dmwufgpEToWqxAC6KDvmVaOXCnh9dHURq0FBfh/8Yd1EjSFhbW4bn5W5poCKc7pPCSt21wMGkObywaCvoCe8g+5HUZUDnw7FXn9X/ur1Mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(54906003)(508600001)(6486002)(6506007)(8936002)(38070700005)(64756008)(6916009)(66446008)(66476007)(76116006)(66946007)(66556008)(316002)(31696002)(86362001)(91956017)(66574015)(8676002)(4326008)(38100700002)(2616005)(6512007)(122000001)(7416002)(26005)(186003)(5660300002)(4744005)(2906002)(36756003)(44832011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWRnM1dPVTVEb0N3WG03VDhuV2hPVzlueUtUeDBzandwL2FOZGFNamYvN2Rn?=
 =?utf-8?B?NmdqQi9GcWhGWWRaTzRqVm5tMisweVUwcVZYYTJGVGJONi9OYVZ5T294dkR3?=
 =?utf-8?B?eU81RHhuSHRhaWFkWW5IZ3FCcUpIb2lUdTFPWldqa0p0NTJvYkRIeElIQk5C?=
 =?utf-8?B?TXBHMnEraDZEYmtWV1BQTFhEWEtHSXp2T1VTOFhOQ3JNUHVSUVpqM3NPNncz?=
 =?utf-8?B?UU5nL1FZYzBYVTVlRmFzZjM3Z1dJN2kzRTJqQ042OENDQlZXVXNFZWNHc1F3?=
 =?utf-8?B?QXhKSjJEMVVoQ0lLZ0szSkY4WVZYQmFiY1M4WG1HVjJ1TmpUTWtZZHJaL2Ns?=
 =?utf-8?B?YnZrWURLaHlsY01keUlCOVhoS2F5YWFnUFZuM29jUXVGQVJTTzRPcDljN0ll?=
 =?utf-8?B?cVYwRWJkcEhkU2RlaSt2NkFHeTFIbi9wdjhIVGFzK1BBV1kxd2wxUzdwbDR0?=
 =?utf-8?B?N2NmRGhmSEFpZGhZeDNDTDRFZmw3TWMxMGFhUnVvczZSZzA3MmdsUUZZbzM0?=
 =?utf-8?B?WVRFQm9BODhuWGc3SkVIelFIRUVsM1I1RmE2dTgvVUxWWnVENFA4L1I1OThn?=
 =?utf-8?B?cktGcUlPcEZuZzVLR2g4clYyd01YdEZnUS9UVHFDMWpvVTJadUQrNGN4dWRK?=
 =?utf-8?B?T2ZEa2xlUm1sUTVabFhONFlDSnozWGJlN09NMlowOHlYZmtHSG9URXFDK3Zn?=
 =?utf-8?B?VGQ2aXJRanRtMWZ3YTNRd0s1MTVmR3lldm0wdEpjREV4T25kOUR4eHJQZnJt?=
 =?utf-8?B?SWxiR2RRRWlNT3pSbWExTVFSd1lnYkMxNElHcTgrMWMzbEdPVm04Q2ZNS3BP?=
 =?utf-8?B?TGVKUGh0TkpDRGVqR3BCYStYcEw1eG5sL3BqUk5PSk1uRzgydEFWVjhaSGtM?=
 =?utf-8?B?M1RiTGxEdFFrYkJHN0xBZTM3T2JPZmE4TllwaWFCNHBCOHpTRi9UdmdsNWh5?=
 =?utf-8?B?VkE3VXhNanZ0L1lsZXVsaDJwdjVxeG1uU25vdUd5VUkzYXgrYndFaEtqckFr?=
 =?utf-8?B?U010SnRuanY0SWFQNVdQM2xRNitJNms1U2RTbENRUFAwSXNBekQrWXNmbS9M?=
 =?utf-8?B?R2tyVVlad2lMOUJhWEZ3blJoMTE3YlJWZHVCZGhWK09kUEo4RTVMTDBhNzA2?=
 =?utf-8?B?OUFvNUkwYzZFZnA0ZnFkRXlvMHhwU2lVVEYzQ0Y0NTBGL1NjbXkyM1B5MUgy?=
 =?utf-8?B?MjlCSWtLVnp3bDlNcVhCR2NQNVdxaG9jWG5OdFczODJ1bCtucGxqOTFVV0FZ?=
 =?utf-8?B?Qmo1TUFxZUp3aUJjV2I3T0JLWFgwSjlGaFhiS2p2S2crRmZVNFRQOHA3WnR5?=
 =?utf-8?B?dE9RMmEwbmFhUngrS2duZFAyT3VGcFBNMDRXL2xVWUJPWG0xbDhsR2VQNmxj?=
 =?utf-8?B?OUhzL3VWMkJ2ZjcxUXdXYXZMYmhpYjlHZlRkQjNHTjhsUWwxUnp5K0htNk9V?=
 =?utf-8?B?dExyY29mdXNONzJ5aUJBWTVsYTJrejd2RFc0TEUwSXNHZHhBRGg3N3NpZVNI?=
 =?utf-8?B?UlhHWW4wZlZKZGhQZHJHYTFGMGJGaDNDOFYxdDdwNjJlaSt4b0NCbks1T0Z5?=
 =?utf-8?B?Q2RKbDZrOVpEUlhOTVNYVVRLWkNKK2w0b2RFK3d6YVB5UXBZNHVGWnhJeU1M?=
 =?utf-8?B?UTBQVnVSNXpDQndvZ1NJSkFKeFJ6eWlDK3ZSZW9rVDRVVHdjaXZraHVEeStU?=
 =?utf-8?B?bld1SHRJUDJzamt3Z1pmS3ZhYlJqaWRuMlptSGpoYWdlbTRuc1R1QitldjNB?=
 =?utf-8?B?NkhDRjI4VHNTZExMSzVzeTBZdW9iQjhJVys3eHdtb0tOdVM5a1NVdkFFNTYx?=
 =?utf-8?B?V1RPUnV3MFZrL2J2ajhyVmxvbXlBandyQWNFaGNlb0RyYjlpTUVoV0VIN3BI?=
 =?utf-8?B?SndsVHJFa2RrNUNXM2VqNHB6QXFpa2xxMVp3QXo4RlF4endxQmZiRGxkVEps?=
 =?utf-8?B?aU1tWlFCN3ZxWC9nOWhnVWpqV3l0emc4a05QMkJWNnkvcm5MUFZCWm9HNStq?=
 =?utf-8?B?dHQ3b1JwamdJRmxUYVZYQUQ3ODgrSXRTTHNIZEI3U3E1d1JlR1k2RCtYdGor?=
 =?utf-8?B?elc3TXBpZWZJLzFYSkEzbVZ2MlU3R2VUZXFMcjNkNEtuaDZTLzI0NjBPbTB3?=
 =?utf-8?B?N3Y2Zi91cmc5WWpmcW5nRkw3Q2NIZEpwdEpCaVpWb1kzTzNzMk9tU2RmbHJ0?=
 =?utf-8?B?YWRBek80M2hxN2M1c0VlSm5uSzlMd2NsVWNtTU45UFRIQkpFcGRSY0w1c2pU?=
 =?utf-8?Q?OZUAIf/l28dup6q7SWiJoEpOiz7bGgOYzT7bGbji/M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E754E6DDD6D77944B5CD628B9D3F64F1@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df30192-1da0-447f-c82d-08d9f0956aad
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 15:11:17.9578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +9GjKub/k0nYHFX6GJ4YrKKDW+JAngKq/YGEdOkP8MvKX2SzzY+TxuRJxs66vIdKj50xOsHiUWN8aj5OmSluiCNjrGTRn/2L88liXIrKVTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB3115
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE1LzAyLzIwMjIgw6AgMTY6MDUsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBP
biBTdW4gMjAyMi0wMi0xMyAxODoyOSArMDAwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+
IEknbSBub3Qgc3VyZSB5b3UgY2FuIGRvIHRoYXQuDQo+Pg0KPj4gICBGcm9tIGNvbW1pdCA4Yzhl
ZjQyYWVlOGYgKCJtb2R1bGU6IGluY2x1ZGUgb3RoZXIgc3RydWN0dXJlcyBpbiBtb2R1bGUNCj4+
IHZlcnNpb24gY2hlY2siKSBJIHVuZGVyc3RhbmQgdGhhdCBtb2R1bGVfbGF5b3V0IGlzIHRoZXJl
IGZvciBzb21lIHNpZ25hdHVyZS4NCj4gDQo+IEhpIENocmlzdG9waGUsDQo+IA0KPiBJIHNlZS4g
SW4gd2hpY2ggY2FzZSwgaWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSwgd2UnZCBoYXZlIHRvIGln
bm9yZSB0aGUNCj4gcmVwb3J0IGZyb20gU3BhcnNlLiBJIHdpbGwgYWRkIGEgY29tbWVudCB0byBo
b3BlZnVsbHkgc3VnZ2VzdCBhZ2FpbnN0DQo+IHJlbW92YWwuDQo+IA0KPiANCg0KSSB3b3VsZCBh
ZGQgdGhlIGZ1bmN0aW9uJ3MgcHJvdG90eXBlIGluIGludGVybmFsLmggdG8gc2h1dCB1cCBzcGFy
c2UuDQoNCkNocmlzdG9waGU=
