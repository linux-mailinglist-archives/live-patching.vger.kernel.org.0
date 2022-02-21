Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5A74BD7F6
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 09:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiBUIQC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 03:16:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbiBUIP7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 03:15:59 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90047.outbound.protection.outlook.com [40.107.9.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8BD1275E;
        Mon, 21 Feb 2022 00:15:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV6F23l9aNQfWbAhpcJXkbzeRRC+j9zhzdcg67/dTdqGHED8gIAqNuEPxpotFGUW7yQcIW0xuVgb1ob3Uo2zYusfSoaJEHR1wvBCS9FSLFG8yf5UZkHSksqv/qUIEDoUTyX8GynXr8iWpbwbaeUdEmvO93FzIHkgtLHsMY3NT4/bjnZ55EGdV4efFWkn/4IEE86ga7gP++22QMSaBeZV3sWaOzot2WJSn4EBYjjgDCnxI0iYLZHOo+S2OlHDc7ZWcsGaQ6qlVtCOpLvma/YmAjsgcd/72pplHdA2Pg9RBs3KxlPHhpKRJGrlRXIEh17jbbNaRVgc5M+B5m7d3ZLOMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPOPnfIFhv6puUR9SDftzbUgFoyjXqFBAH41qJGZuxI=;
 b=V1T5KU8jP9AgQrxhRAB2tbEPc9bx1ik6zzA/AeJaCY4hxUo6BGCU/Ess5Eu9QLwX9VU1QF3k8yBoWZLfTavbxKoyYm/d3gNYQQgRC+0fBvxbzo69ycYCu8QkweuoQK0hMtkOKNX/XTM7KzrodDZltV/YLsl9iQGMJRBgclCOd0w7g2LiIRIWOdMP/M1JQJxebPuQ9fOpG+8zZH+WeAs4z7IABxqGOr9dTOX9wNz/zwy3Mw3WcHh0pAMJX7VBof5IFUJGZenymPCgBpcKORGiFXg53sDzMkZ84FgNLnWO/7C3kvdVYC8UtrezGRbbg2dq4nzs3yLt+PPB0dOJYuUDyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRXP264MB0902.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 08:15:32 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 08:15:32 +0000
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
Thread-Index: AQHYJQ4QuMcWnRXchEuo5UQTg6cwKqydrEiA
Date:   Mon, 21 Feb 2022 08:15:32 +0000
Message-ID: <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu>
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
x-ms-office365-filtering-correlation-id: ca3745c8-4b36-4b20-643b-08d9f512545e
x-ms-traffictypediagnostic: MRXP264MB0902:EE_
x-microsoft-antispam-prvs: <MRXP264MB090201D19E023404D7D8E678ED3A9@MRXP264MB0902.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AEgiWRGZevOYYzDUioNQK82VAYO1MPcVQCEDux28L328WpT1XTT3SZ7p5bbR+fAw0JOwtKQozytWPJveGfint29YFkPXFG4DjUFbRV7BUiEhRe3N4IbFI+yB3SKsOtw86Fs+mhXDg438bVoXLDFjXbaLl+wTik3BRIdRiPGVX53gumO+3whd9kpbk9ynST8WEBO35YVN+QQdbeoDfuqnJhXZUjZD144tge2Ru+Nd/76zcARWP4+tSXzbIssEYondm+ply+/HevvGU5qKxEPOqYMqZAxDObubFK3D9VbkIql5EZE/OcGSyjBNjfc9AB2X8wK7RNlYVxJzygW5NKRSC/KCe0o/OmIr3XTFVkFUernJtfbOvwI3NHS0FIpbsq2VUo+ek8ZVpRa42vWf1eMhey0zLmwystqt9LAT9qri3Rxy0ReSUKHxoRIgckLzH0nd1TaqCzkDqu/PKnNoRSXdrw12tFjgfF3yjunurhSSTARTCiDp+5CMje/K0/2t+2pUuoxrAIA0Py0eL6qefMNOXp2ZzqcSQ/hZDVacLId0aq01K8cPT16fcUaLTurKGx8hegrglvkPbFWWLf3FyWymMGe17kZyCVX5hiyY38HHFeZWgAag0wB0zBxzwJt/jnlVMtQdNpK7t1TWKN7GtZHfiCsILzgLunjpkSTb3HDqpQ0qiVowILQwBmKurs2JMwMjFbD5ulEH6Cxnm0QRg5pqQdWyRR758melWw00gXmwFzPGLKbXNbsuYR6hXDF1SrjNBB1NRcA5DsERLDYPf26kUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(6506007)(54906003)(110136005)(7416002)(36756003)(44832011)(31686004)(66574015)(8936002)(5660300002)(26005)(508600001)(6486002)(2616005)(186003)(91956017)(45080400002)(66946007)(38070700005)(4326008)(66446008)(66476007)(66556008)(64756008)(8676002)(76116006)(38100700002)(71200400001)(6512007)(31696002)(86362001)(316002)(122000001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3RSR1BiOUwwKy84azRvcHZndENqU1JPTlFkenhGVC9hU1BTbERTcUpuNmM3?=
 =?utf-8?B?ZG9TbzJ4RUlwa0E2UlczUHJkaHV5ejFvZ044TXAwV05xdmNvVXRKM3dvaHRE?=
 =?utf-8?B?eXlsejlEUGQ0a2F5eWNiaFdJOFRIalA5MmN4dXZUOVg0TlhDeDZvYzhwS3Ju?=
 =?utf-8?B?Z1JJR3FPZysrR0hyWDZLVEkyZ2NUV1ZtMzRBb3d3akhQOHlidFBXVnNIaGlQ?=
 =?utf-8?B?UnZVMVBUZXpnZTVncDJBR05kb1FzbDRmK0xBN0x3OWJqN0JCYU9qYkxXY3ZK?=
 =?utf-8?B?WVpDMk0wakVlbUlNSnQ4TTNaamhMQ3RMdnEvWnBCRFFieDV5QmNRUVhSR0la?=
 =?utf-8?B?RG1VV09LYzh3R0JmcWVEQldpd3RkVGF3RjBxTGdCbEI2eUs1eVVybllMazZu?=
 =?utf-8?B?elorNFBLdjF5UHpLYzEwZnZ6eGVpSy8yL1lqQnpuajdhRmRkSnF0dG4zNW1o?=
 =?utf-8?B?dDhvNjVFdmZiSXpKWmFUUng4bG9oUVFCUlYxTFF3bC90ZXJ3VC9hK1FYMy9P?=
 =?utf-8?B?TGhKc2phVDFlV1N2SnlJbDliUTlJS05RbHk4dnFMeWZ4QTV6V3puUUJJTmQ0?=
 =?utf-8?B?S0JHMEt5M2xEaGVqQUE3QmVTYnlvQU9ERzFMa0tpeWtHcjZYelNGZ1RtbEJh?=
 =?utf-8?B?R2QrVTJPS0xLVTRYM2o3dUI3azYzTWpQMUlnYitPTGJWdXlpbjZNOXU1SDBl?=
 =?utf-8?B?U0Vkd0VMTHJjNUZCVHY5RG5IdisxdjhmN1Z2OUgzNGZWdElZUUdLTTVSVGdn?=
 =?utf-8?B?M1hNL0xxRzhmWUMwdXZ3MSsvalhsdmRqZEtiZktOaHQxVkQxclZ3UzNGSHMw?=
 =?utf-8?B?WUtET2l6MVRWWXhKbTR2akFtSHh5T2g0TzErRUNXRlhtc0FUQWhsNTl4Mngz?=
 =?utf-8?B?N2MvSzZsUGlDc2pMaW5ZbWY3RTRvcm5vSlFoWlNQTWFrNkx1R3hFVW5LTG5I?=
 =?utf-8?B?OHNRQnlGUnNCUnRkVnJ4QVQxSlVscHFjVDJOakh3aXg0QmUxUHhZbzFNNllr?=
 =?utf-8?B?T25MSlM2YVFUV2FZa0dEc29yU25XWnh3c050TEdxTGppLyt1OG1sRVFaU2pO?=
 =?utf-8?B?ZE5NZndKVzVycGU5K0xDMG9jbkd5TWZPdUxPcmdHYlc2QjBIeXhsdnpudlRX?=
 =?utf-8?B?RGc3bnN4aFlubE1qM0Vka2pOY05TKzI5U0c3UFp2MjA3Z3FVeEV1N3VLTzhZ?=
 =?utf-8?B?aE5hUm94OWFSZmlkTlRZblpjci85Z0FXRVpaZDhRa01pNlgzNkNXTXRhOTVT?=
 =?utf-8?B?Q2JuNWJ2VEZOd1BvMjJvQ1ArV2tqcEEzcUdWWUtTUFB1N2pWa2pHZEJzREhQ?=
 =?utf-8?B?RmhGVEQwdGMvdUpUbHFNOWxRUzk5RFBQcUZtSC9UNVVPaS9vVlN3MnZqVW5t?=
 =?utf-8?B?eFJKQjBGTER2ODJ3S0hpK3ZtaHRxQUZNZ3h0cjd3Vk5ncU5MZUx4amhjSTds?=
 =?utf-8?B?cEZNYjZ4Z0hxSGpoTzZ6Vy9YTnMxMk1ucytsRFo5dmlPUFNCL1dzcStGNEQw?=
 =?utf-8?B?cm5IekI1QitwZG9EZDZLL21JbnptRTZCWWY2Wjk5OWxPamlVRjBwWjVkRFUx?=
 =?utf-8?B?MU0wN1FCb0h0WkVSWjFxV1VZUkwwSm82aHFKbjZzV0U1a3g2Y2tieFFHM3RT?=
 =?utf-8?B?ZUJ5WVJENkY0TzZTVThhbzR2MklPQW1uZGU1Wlo2SmZ4R0REUytPSkdQSk02?=
 =?utf-8?B?RTJOKzdaczJiUWdHZURiWHB4dTNPYkdhclBBRGRMci9hdzFXNnYwUXlWaGxI?=
 =?utf-8?B?RTlabG5YaHVPVWp1TXBCNTdPazRJZ0JVVjlKbkJKS2ZDTStnNjR6c3ZZcnpj?=
 =?utf-8?B?VmY3Ni9MNThrM3JZMld1NVZ0cmkrdnNzNEF4SE5CWjh4cjlPTWNkKzUrNE1r?=
 =?utf-8?B?dUlZb0hiT0xVR1Q4Z1hPbjlOZFdMeXp6djdhUXl4SVlGakxYdEpGaW1ublJz?=
 =?utf-8?B?VmVnTzZhTStSaDBPZE5MR01VeU80RGd5QlRaK0lvME1jT2xpL1ppZWdqVURi?=
 =?utf-8?B?YWRNOWpQWlRESUpaWGdDVitSWE9oeW9kQ2lITkdTSGJhV3lEM21xY1FPSUdk?=
 =?utf-8?B?V0oyQjMrQWhpNjcrQnJSQ1JHOFFRdWxCbGpSZVNVNEtZVkZFODB1RmRJbjhV?=
 =?utf-8?B?TEFKN3U4WkRycEwvTzZFZWRibDhWODRJUmJKUUZYVDJ0WERjdkU2ckEwSU45?=
 =?utf-8?B?MDAzV2hSL1hMMUhXcDgwclZaTExqNDlhUDRQdjlXN2hFRG0zSDcrelpiQnNR?=
 =?utf-8?Q?dlh2AGAaCF8lVFGg+wRRUg/n+UkL6f1WAC1UjUFyc4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF294E04655D724FA20A31CAC3557844@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3745c8-4b36-4b20-643b-08d9f512545e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 08:15:32.2543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Nm/6b3eX26/9l1oOvIUMkKjtC78Br3sXJMyhTQoExYDXnDZY/6+VhuX+p9jJT6hC2BEVi/DzaGqDU2QkUfaA/zJqiIzB533U8vagQ9gBK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0902
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE4LzAyLzIwMjIgw6AgMjI6MjUsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMga2FsbHN5bXMg
Y29kZSBvdXQgb2YgY29yZSBtb2R1bGUNCj4gY29kZSBrZXJuZWwvbW9kdWxlL2thbGxzeW1zLmMN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIFRvbWxpbiA8YXRvbWxpbkByZWRoYXQuY29tPg0K
DQpXaXRoIHRoaXMgcGF0Y2ggSSBnZXQgYW4gT29wczoNCg0KWyAgIDM2LjQyMTcxMV0gQlVHOiBV
bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBkYXRhIGFjY2VzcyBvbiB3cml0ZSBhdCANCjB4YmU3OWJi
NDANClsgICAzNi40Mjg0MzVdIEZhdWx0aW5nIGluc3RydWN0aW9uIGFkZHJlc3M6IDB4YzAwOGI3
NGMNClsgICAzNi40MzMzNDJdIE9vcHM6IEtlcm5lbCBhY2Nlc3Mgb2YgYmFkIGFyZWEsIHNpZzog
MTEgWyMxXQ0KWyAgIDM2LjQzODY3Ml0gQkUgUEFHRV9TSVpFPTE2SyBQUkVFTVBUIENNUEM4ODUN
ClsgICAzNi40NDI5NDddIFNBRjMwMDAgRElFIE5PVElGSUNBVElPTg0KWyAgIDM2LjQ0NjQyMV0g
TW9kdWxlcyBsaW5rZWQgaW46DQpbICAgMzYuNDQ5NDM2XSBDUFU6IDAgUElEOiAzNzQgQ29tbTog
aW5zbW9kIE5vdCB0YWludGVkIA0KNS4xNy4wLXJjNC1zM2stZGV2LTAyMjc0LWc3ZDRlYzg4MzE4
MDMgIzEwMTYNClsgICAzNi40NTgyMTFdIE5JUDogIGMwMDhiNzRjIExSOiBjMDA4OTdhYyBDVFI6
IGMwMDExNDVjDQpbICAgMzYuNDYzMjAwXSBSRUdTOiBjYWY4YmNmMCBUUkFQOiAwMzAwICAgTm90
IHRhaW50ZWQgDQooNS4xNy4wLXJjNC1zM2stZGV2LTAyMjc0LWc3ZDRlYzg4MzE4MDMpDQpbICAg
MzYuNDcxNjMzXSBNU1I6ICAwMDAwOTAzMiA8RUUsTUUsSVIsRFIsUkk+ICBDUjogMjQwMDI4NDIg
IFhFUjogMDAwMDAwMDANClsgICAzNi40NzgyNjFdIERBUjogYmU3OWJiNDAgRFNJU1I6IGMyMDAw
MDAwDQpbICAgMzYuNDc4MjYxXSBHUFIwMDogYzAwODk5YTAgY2FmOGJkYjAgYzIzMGE5ODAgYmU3
NGMwMDAgY2FmOGJlYjggDQowMDAwMDAwOCAwMDAwMDAwMCBjMDM1NjI5Yw0KWyAgIDM2LjQ3ODI2
MV0gR1BSMDg6IGJlNzVjMDAwIGNhZjljOWZjIGJlNzliYjQwIDAwMDAwMDA0IDI0MDAyODQyIA0K
MTAwZDE2NmEgMDAwMDAyOTAgMDAwMDAwMDANClsgICAzNi40NzgyNjFdIEdQUjE2OiBjMDc0NzMy
MCBjYWY5YzlmYyBjMTFmZjkxOCBjYWY5YjJhNyBiZTc1YzI5MCANCjAwMDAwNTUwIDAwMDAwMDIy
IGMwNzQ3MjEwDQpbICAgMzYuNDc4MjYxXSBHUFIyNDogYzExZmY4ZTggYmU3NGMwMDAgYzExZmY4
ZmMgMTAwYjg4MjAgMDAwMDAwMDAgDQowMDAwMDAwMCBiZTc0YzAwMCBjYWY4YmViOA0KWyAgIDM2
LjUxNjcyOV0gTklQIFtjMDA4Yjc0Y10gYWRkX2thbGxzeW1zKzB4NDgvMHgzMGMNClsgICAzNi41
MjE0NjVdIExSIFtjMDA4OTdhY10gbG9hZF9tb2R1bGUrMHgxNmY4LzB4MjUwNA0KWyAgIDM2LjUy
NjI4Nl0gQ2FsbCBUcmFjZToNClsgICAzNi41Mjg2OTNdIFtjYWY4YmRiMF0gWzAwMDAwMjA4XSAw
eDIwOCAodW5yZWxpYWJsZSkNClsgICAzNi41MzM1OThdIFtjYWY4YmRlMF0gW2MwMDg5OWEwXSBs
b2FkX21vZHVsZSsweDE4ZWMvMHgyNTA0DQpbICAgMzYuNTM5MTA3XSBbY2FmOGJlYjBdIFtjMDA4
YTdhOF0gc3lzX2Zpbml0X21vZHVsZSsweGI0LzB4ZjgNClsgICAzNi41NDQ3MDBdIFtjYWY4YmYz
MF0gW2MwMDEyMGE0XSByZXRfZnJvbV9zeXNjYWxsKzB4MC8weDI4DQpbICAgMzYuNTUwMjA5XSAt
LS0gaW50ZXJydXB0OiBjMDAgYXQgMHhmZDVlN2MwDQpbICAgMzYuNTU0MzM5XSBOSVA6ICAwZmQ1
ZTdjMCBMUjogMTAwMTQ0ZTggQ1RSOiAxMDAxMzIzOA0KWyAgIDM2LjU1OTMzMV0gUkVHUzogY2Fm
OGJmNDAgVFJBUDogMGMwMCAgIE5vdCB0YWludGVkIA0KKDUuMTcuMC1yYzQtczNrLWRldi0wMjI3
NC1nN2Q0ZWM4ODMxODAzKQ0KWyAgIDM2LjU2Nzc2M10gTVNSOiAgMDAwMGQwMzIgPEVFLFBSLE1F
LElSLERSLFJJPiAgQ1I6IDI0MDAyMjIyICBYRVI6IA0KMDAwMDAwMDANClsgICAzNi41NzQ3MzVd
DQpbICAgMzYuNTc0NzM1XSBHUFIwMDogMDAwMDAxNjEgN2ZjNWExMzAgNzc5MmY0ZTAgMDAwMDAw
MDMgMTAwYjg4MjAgDQowMDAwMDAwMCAwZmQ0ZGVkNCAwMDAwZDAzMg0KWyAgIDM2LjU3NDczNV0g
R1BSMDg6IDAwMDAwMDAwIDEwMDEzMjM4IDAwMDAwMDAwIDAwMDAwMDAyIDE0MmQyMjk3IA0KMTAw
ZDE2NmEgMTAwYTA5MjAgMDAwMDAwMDANClsgICAzNi41NzQ3MzVdIEdQUjE2OiAxMDBjYWMwYyAx
MDBiMDAwMCAxMDEzYzNjYyAxMDEzZDY4NSAxMDBkMDAwMCANCjEwMGQwMDAwIDAwMDAwMDAwIDEw
MGEwOTAwDQpbICAgMzYuNTc0NzM1XSBHUFIyNDogZmZmZmZmYTIgZmZmZmZmZmYgMTAxM2MzYTQg
MDAwMDAwMDMgMTAxM2MzY2MgDQoxMDBiODgyMCAxMDEzYzNmMCAxMDEzYzNjYw0KWyAgIDM2LjYx
MDUzNV0gTklQIFswZmQ1ZTdjMF0gMHhmZDVlN2MwDQpbICAgMzYuNjE0MDY1XSBMUiBbMTAwMTQ0
ZThdIDB4MTAwMTQ0ZTgNClsgICAzNi42MTc1OTNdIC0tLSBpbnRlcnJ1cHQ6IGMwMA0KWyAgIDM2
LjYyMDYwOV0gSW5zdHJ1Y3Rpb24gZHVtcDoNClsgICAzNi42MjM1MzRdIDdjN2UxYjc4IDgxMDQw
MDM4IDgxMjQwMDNjIDgxNDMwMTAwIDU1MDgyMDM2IDdkMGE0MjE0IA0KMWQ0OTAwMjggODEyNDAw
MTANClsgICAzNi42MzEzNjVdIDkxMDMwMTVjIDdkMjk1MjE0IDgxMDkwMDBjIDgxNDMwMTVjIDw5
MTBhMDAwMD4gODEyOTAwMTQgDQo4MTQzMDE1YyA1NTI5ZTEzZQ0KWyAgIDM2LjYzOTM3Nl0gLS0t
WyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQoNCg0KQ2hyaXN0b3BoZQ==
