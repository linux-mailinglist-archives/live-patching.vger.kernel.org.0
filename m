Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1952E3A95BB
	for <lists+live-patching@lfdr.de>; Wed, 16 Jun 2021 11:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFPJRV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Jun 2021 05:17:21 -0400
Received: from esa9.fujitsucc.c3s2.iphmx.com ([68.232.159.90]:24961 "EHLO
        esa9.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231336AbhFPJRV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Jun 2021 05:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1623834916; x=1655370916;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=v0DdaD1fEEmqElzuyThiCRzrCZ93pz8XK4kNp0pwI/Y=;
  b=ufkt8WPtW9OLxAHzIL6+w062dE5u3FCxvbI30BngNa/zYKDfT4GWre5B
   krcqj5BNnU8+/FU0t9leCOaWNBE0GmB8nKOgFH0zMntGzo6jWi1Tki8UA
   lVOkJbdDfG5XuVAfd2m5Mc5HXVjIsblFz6RMCF1jYg0kciMNALYGYXeUp
   l+ObfOQ/BQdbh2s0B0M5YBAphD3pW8Zs4g+E8levR+PtRbCGdkt3IftgK
   kiwj7/jx/zm3nTwxEBQHAEL5eGPhAS9Ql18QPHFZ8HC2YCwtcEAiK6d2G
   sROdtcPoaTaGK25XW5UE4o2ohXurZ4x6pSLO6/gzRQvxOtdAmIrELk3GI
   A==;
IronPort-SDR: UZC6KczQudvHZ8WxSpJ5e1CBfXb0kjgtKtp44YtBVzdsJhg3vZ+rhOcY+d3bC0aXqkpShhNmdX
 qEpgS5FSYDVA6kDZM5jH0/TYzgIiHyBipISeUCZyDTmBZ87cN9F5n7KQHN3Npwe7mb7W5814lI
 7yzcRSIrSp5P6b3ae/LEG+K/yhWUlPgTtmM5A9LC/EnV70gIaskb03c5QUmQ4HqKllB7BgP4LE
 hpWdIkryxggDLzi04DheYxIofIp5pAAAnoAKfWdzHDLh9biLGhxD5A5fMx1Fs5tv/xg5EG/Dzx
 /w8=
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="33252411"
X-IronPort-AV: E=Sophos;i="5.83,277,1616425200"; 
   d="scan'208";a="33252411"
Received: from mail-ty1jpn01lp2053.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.53])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 18:15:09 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXERfewe7wZOqt2Lx1n0HjqjjwzRLYzv2OANeu5LspnpTvMLL0qeMciZcVzaS+nxlFpnqvKQP8PBhflgDsyT7ViTeaBGXaEjW8fW7slXIF4Ez4mItvuV6u0dFS6wiBzFVZXbjACSYMwALRNI/mEfFPyaX8DYD/RHZ7TXImxr4M1KQNyXB86Sglty0pWzZuPsxkE2LcCuIAhALldCfok6AnghsZmVR2xT6L1hpry02wpZsMp7CfSXnQ5bPiGVL047VWZthuekOqoN+/hX5LRGLzb/Rb5RHEKhZiLw7ishh/UbEJnBz4A2ZmyH6h4qErsbsJdU8utE6mbsonBsQohoBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QXD5GE3JlnYaJkD8WRbIm9NX+Pe0IiECRvSWbpHWHg=;
 b=eWTRLF+QA9yXTZ21dtwkD1NbDGD1djOeKuykikdhX52tXCEK6LcO2PTGpDnW24iU3wtg0lg+wrAdQ6G4pOComJdHksqEyODatX8QfbtfGyyuyZOG6Sa5dUqUcn/TlmAqtjyG81GOCCIs35cW+nGohWhxMQf7dhXDpjbKMSAsRL7qaXk55yLr+Zu7ziUcgIL9yS2TP1yWmpKpGDCEDPrE2D1cW0MwposSz4cOfKoA5U0rRCT3octaG2yroXZ5gre1rmQtWnZKP8uBjAf9LA7UwxhSNzjyuWDQgSfpyre8xT4RAdIkcKP8LgFigQ4pJKSR/4J/XJS+flmmQzWP1jJU3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QXD5GE3JlnYaJkD8WRbIm9NX+Pe0IiECRvSWbpHWHg=;
 b=XMWboTq7B6sHk6ZL42H5gQaCAp1fZIz+n+GG9frEYvama6v1654yul1tmmgwZHTxOazNPOOFLbBKvT6Sq/yAodMOyRcXzzYUYUTUvqx8NpN+dHB+1DUFo6kvgi0OzJxmaZuCkXkqi1bEVNRUGjHlmSi1RZEAHdqfI6HNzbe+x8E=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYAPR01MB3309.jpnprd01.prod.outlook.com (2603:1096:404:cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 09:15:06 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::1d6f:5a3b:9719:a811]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::1d6f:5a3b:9719:a811%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 09:15:06 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     'Suraj Jitindar Singh' <sjitindarsingh@gmail.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
        "jthierry@redhat.com" <jthierry@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Thread-Topic: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Thread-Index: AQHXUnkEGTjowitNFUOpYKuZUbtb4KsV/3OAgAB5zCA=
Date:   Wed, 16 Jun 2021 09:15:06 +0000
Message-ID: <TY2PR01MB525710706D9D48563F240052850F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
         <20210526214917.20099-1-madvenka@linux.microsoft.com>
         <20210526214917.20099-3-madvenka@linux.microsoft.com>
 <712b44d2af8f8cd3199aad87eb3bc94ea22d6f4a.camel@gmail.com>
In-Reply-To: <712b44d2af8f8cd3199aad87eb3bc94ea22d6f4a.camel@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckermailid: 42e78a8635aa4f5584ac4871d4cc5762
x-securitypolicycheck: OK by SHieldMailChecker v2.6.3
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-06-16T09:07:56Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=0ce0e82c-9a3b-4088-b667-5aa5e86b7890;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [210.162.30.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f88495da-3550-47c7-ed81-08d930a73b53
x-ms-traffictypediagnostic: TYAPR01MB3309:
x-microsoft-antispam-prvs: <TYAPR01MB33099A123953357E2A945475850F9@TYAPR01MB3309.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ny2QXxk14WD1F/1R7U92qn/AzYsEZk8u/iCUFHOPblamlS+uMbtDX60Zb2jXIj8UaTeUSJRS4kgDpyxLdstIQlErRVm4t+TqY+lJ88uPaAdooUv1IonvRiYYtMJcMJIKv+5eiNR0kFXekyOCYS4aIc9x5WTzZZVF8LT4m7sUCTGFVlVBwrTlq6lPcbfdK0peMlgkr5jXCbiTYzzirkjZCzxdO3EdeZdnNNig1FzS6SBQqPwwHkJUUgA8J0knMspjLWqhekGJMt3JtZ7HBhfJXDH2saOFJA3hQEOeVmTr1ovx1oAKEvkK9BNIpSI3PCWfxq6KbAY6CcqqhTjgV6mylAz2wnfxl2CEYcsYMpajrNKp7uexZUjrzdsm/Gu/qIIbhwQKtuJQK6bUzREMchOFjS63vtmufpNsx8ftbJ05ItgdCgsyeyBcbXBezzQWfMLJo3GC7tpWZdwU4g4Qt3iyTGsXV5noPbGq7ia+kiaUh35xDasgtzIKbtYmlmrZqdHZX4Gy1TkXCTmB+Ou671H5GwOR4QMWnvYVa4BA4z2dLH9gd5EHgBdTLLF5OUBcJwL1xiGHzuOVA27Wa3ou0QGCHsSNXssLGtb/Vkp+kt1GktAbpiye3mqJEdSLzD0rfgXc96uCvJjm4JJPZCpOGKW3SPIAmMg5wZJhiBLLZGdNPWVJy4mRRetBTLoc4VXjLod1kTS3UDqViodJaOPw7O3BLRjatas43aQV3o/n3js9BpwEflQu7M24zVWx4apr9O7H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(4744005)(6506007)(71200400001)(921005)(5660300002)(7696005)(9686003)(33656002)(8676002)(55016002)(76116006)(66556008)(66946007)(7416002)(38100700002)(966005)(110136005)(64756008)(2906002)(66446008)(52536014)(66476007)(186003)(316002)(86362001)(26005)(122000001)(8936002)(85182001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?cXhkcFJqelFzRkt0cThGMlZOMndLWExmVUFIRHhlUTduS2V1WndyRHcv?=
 =?iso-2022-jp?B?Z0lyNmhTcWJDcUVSTDU4NnI3aCtLalpRZEVYMHorRU5ESTFpck9iWGZK?=
 =?iso-2022-jp?B?TGEyQnk0aXY2Ync1aGxSNlYvWnVpOTJ6dkM2OXBUOGJtejIzdmk0ZmpV?=
 =?iso-2022-jp?B?NEU1TDhBVVRlbjN6VGNkWWZBeEI5NEgwMFlKeUxLdHc1NVJLMHpEenUx?=
 =?iso-2022-jp?B?U2dYS1dma2hSbGJ0YklMZGluRGhsYkZNSkRjZnBQSXl3LzVmNHRaTmxo?=
 =?iso-2022-jp?B?aEhYazQvZkdmOFZwbXlDSHNkOVVWZ1BqVG1HRFo3aU1FQWFXL1l1UDBi?=
 =?iso-2022-jp?B?aGhtUXdyS293OHBRa2hXMGFnNzhEOEpmZEJZT1YzMXVEcEtXM01yMWI1?=
 =?iso-2022-jp?B?R3ZyTnhoKzd6b0E3TkRFNWd1N1MrRElyK1FEZzlJZFI2Tk5kYmpkbDVD?=
 =?iso-2022-jp?B?SExmZU5QdTZISnFQNG1uc1lseXdEeHVJK1I1bGk1MGFvMTVMUmkrempV?=
 =?iso-2022-jp?B?anBPM2Q5UHlzVWtIU2RHaGtWMSt2WnVPMzJJNUNtUWwrc1hIVy9FZVlj?=
 =?iso-2022-jp?B?bEhoeHVsazNpUXZwTWRZaWJJSEdtdFlFYWdYRmJhNlYvUmdPNDZDRGll?=
 =?iso-2022-jp?B?TWpsTFpSVTdoU0txTkZ4K3VHbzdIbkEralROd092Z3lRcmZKamFZNG9O?=
 =?iso-2022-jp?B?WTlVN2U4YXM4emlRY2NKOUJLVkNMWlk2NDBhRUlWdVRKQTU5azVZaGZJ?=
 =?iso-2022-jp?B?OXBTUllpUVpPODZKejdxaGJwY0Y1ejREY3ZCWnFnQndZQWs4T0gxR2lX?=
 =?iso-2022-jp?B?ZUZ4Q2FBKzlWSUo1cHNDY2FFTDBwamdnR05tSWw3SHMvMDJJRzdIZElY?=
 =?iso-2022-jp?B?cGtqV2s3Q2VmMFduYmRyMGhKMHJRZERJQ1djWTlRZm1lT09FQUJ5ZnNC?=
 =?iso-2022-jp?B?YmFUcEdFNzFBbW5ob0duUUYvcnJnQ0tkQTA4aUx2V2JhY1kzMS9ralZk?=
 =?iso-2022-jp?B?UEUrU1lwQlhqdzNpOVBPNHJaR2svcGdCenVOcldYRkNBQXVZTTk5Qld2?=
 =?iso-2022-jp?B?bkpjMDdqYWViQTh5QlZjeVBjYnlNdWlLMkFOcEhCdk95eWhVbE5iSjRm?=
 =?iso-2022-jp?B?VHh4OVZLRVBwcStYVXRIbTUrUDl2ZGo2SEpiajdtNit1MURMUnlEM2p5?=
 =?iso-2022-jp?B?S2xCbm1EYUQwemlvN1BPU0xWZEZvMHl2K05XSkRTWGZ6dnFiVng2cWhT?=
 =?iso-2022-jp?B?cUNncVVpSTUyTGdaVE54MDg4VVpYVWNTdnJ4V2REaG1qL08wUjBoV2pQ?=
 =?iso-2022-jp?B?eG9LV3NPeVhpc2hBenRXc01HVGN2aTQ0SjJoSzF1YWRYWU85Ni9uK2lL?=
 =?iso-2022-jp?B?QXRONlBjc1Y1ci9zWFdaVXdXaTNwTlV4RFlqVWtnTlY2VDJmN2VmSjNl?=
 =?iso-2022-jp?B?N0MrU25GbWRuMVp5K3BMak5sMTFlNzMrRWsvLzVnalJ3cldTZFZUT0JM?=
 =?iso-2022-jp?B?NW5GcWQ4djd4RDMzeksyZnJjWVhteUJnaUhLbjloMlYyRWNDaFhMRVVO?=
 =?iso-2022-jp?B?bTNwa1I4dEhhTFhGQVZDRXhJb3kwN3hrUDVqUTBtQ3hMb3J0Ui8xYm9w?=
 =?iso-2022-jp?B?Mm5Xa2NYcm9uWVk3eCtCQ3VYVFpmdkc3NXNYNytkMGhWTVA4ZkRxRWlH?=
 =?iso-2022-jp?B?TUR0VFh2elBtUU1tT1JCeVE2VHAyYVNDbENEVW0vMVVJc01DblJDOWlo?=
 =?iso-2022-jp?B?d2JLdzhqT01YRDNENVN0Q0pPc1pETGUwZ3FBY3loRDZGVEo0SDlvV3lE?=
 =?iso-2022-jp?B?elQzSzRSaXFkZnB2cTd3ZnkzWHp1T2huS3U1M3JkOUlieWZScVl2ZFhx?=
 =?iso-2022-jp?B?NVEvdmJQVGhlQm9RNmU4dFBVNFBVPQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f88495da-3550-47c7-ed81-08d930a73b53
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 09:15:06.2223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YesLkmyaKNL4xm0q5z/mPXs1aVN9qisZsAEC1EKGuA4OjZOIsZn+y+NNRepXClQJeEIvyieqUmQbuCJEFP+vuKR5ApWpnPDzkrSHS+02BIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3309
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Suraj,

>=20
> if (frame->fp =3D=3D (unsigned long)task_pt_regs(tsk)->stackframe)
> 	return -ENOENT;

If I understand correctly, a similar final frame check is introduced in thi=
s patch:

arm64: Implement stack trace termination record
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=
=3D7d7b720a4b80


It is currently merged into for-next/stacktrace branch.


Thanks & Best Regards,
Keiya Nobuta <nobuta.keiya@fujitsu.com>
---------------------------------------------------------
Solution Development Dept. Software Div.
FUJITSU COMPUTER TECHNOLOGIES Ltd.

