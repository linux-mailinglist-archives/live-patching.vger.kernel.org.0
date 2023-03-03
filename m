Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3E6A944F
	for <lists+live-patching@lfdr.de>; Fri,  3 Mar 2023 10:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCCJlq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Mar 2023 04:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCJlp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Mar 2023 04:41:45 -0500
Received: from esa18.fujitsucc.c3s2.iphmx.com (esa18.fujitsucc.c3s2.iphmx.com [216.71.158.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650E727D6A;
        Fri,  3 Mar 2023 01:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1677836505; x=1709372505;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CMsl8wWDddGCHGyqY9StHDn7PQLR1fQgF/+l3eY5/tk=;
  b=QuB596kD8z72gDySqzK8UFJKIy94M1rMdrfKGBG03uLJo/EZVEv2PAE0
   2aU8r7RbbZI/mTaMVobv29bAVAk0BHMw0V04AKoAUeFj/KH3bq4O79Noc
   tSQpzhWRkVPttGEw+3hem3IHW/j2El46xDFjbuYk7UmArNX45oTP8PpRY
   ssZIHH/WFuriZDQgkWUEH0I5PoVjcY35I4GFENR3EmTUOfnMshSQrOC8t
   OoD62VleO3uVARkcWbnPLm4TH7sJqRTStjXvPjAAZOWPu/Ny6I5SdOzPI
   5JJgQndFahiCTUENC8OX9X7Cap0nqZ5dCJ0y1MjZzC3hUVVZ6wLGUEe81
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="80687928"
X-IronPort-AV: E=Sophos;i="5.98,230,1673881200"; 
   d="scan'208";a="80687928"
Received: from mail-os0jpn01lp2111.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.111])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 18:41:38 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QG6Uw4Sjwgu9Ay4q6+JqRtyHf7MICbNpPHZxh94qhXu/qy8HONdODpoEudQVpMY/7W3xj2S92qG2dE8Dc3YOPPWchtl4w/wNLTsitM7T46XdBXmfVz25MFLBt7ZYJ9YHfzoNHPjPSJGErZNBVvYyw6WzRXoG9WW9Cp3MiX38hxRq0S2oNzVl/qCKcD21EAr3EWag9qtRzVHr0/D2kAUN3U5qeHMzGqp8tnc+bBOj103idri+YabcpjW54tNmOVgFRDpiBzWaKbL5sdYzbu52TRPI/0y92TOVrNQJgKgpq+tU/7ZE7qDP1j3qKyy3lelOAzzm5ixBDg3vblLjFuRJQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aN+ems4mGJ/hxQ1QJzK9avF9DPuMxOjC3VxvCukqKI=;
 b=iTNCi0ZnMGGfzzqpHWLEtFYQqi8TTj/7E5he9el2vmaR3PMXB194m1GqjVFwxoB7TpkRlpBCvfqqz7vmDDKTwwr3leeD6VZpN4cr3tn3EQyPXpLR0wcAK4m0SCeL2oH5n9Xe3sycajH+YN41Gkl9mUkEt3ffxNQHRT4UZKni/MhjhwPp7wP0kZPvMmVoSUrrQAYe5kbgqs8UEAzYeOC81Y4cbeGLcMh0byjZmG9YTViQdcaRxIHhk8V2OX9nqTV7P3AkMKq87frI+rpl7HY0NE1ySbaWEcRNo+F1KLX8S7OhOSLYxT5dZa8eZCNSnQhdGjyhqAYlAuHuW5tY3QYQdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB6993.jpnprd01.prod.outlook.com (2603:1096:400:bc::7)
 by OSZPR01MB9281.jpnprd01.prod.outlook.com (2603:1096:604:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.20; Fri, 3 Mar
 2023 09:41:34 +0000
Received: from TYCPR01MB6993.jpnprd01.prod.outlook.com
 ([fe80::fa28:794f:a1b4:8e2f]) by TYCPR01MB6993.jpnprd01.prod.outlook.com
 ([fe80::fa28:794f:a1b4:8e2f%5]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 09:41:34 +0000
From:   "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To:     'Petr Mladek' <pmladek@suse.com>
CC:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "chenzhongjin@huawei.com" <chenzhongjin@huawei.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "Keiya Nobuta (Fujitsu)" <nobuta.keiya@fujitsu.com>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Thread-Topic: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Thread-Index: AQHZNtr2MNh0z0iEfEuTLgtmunaVUK7lZbhAgAJzKgCAARCmIA==
Date:   Fri, 3 Mar 2023 09:40:32 +0000
Deferred-Delivery: Fri, 3 Mar 2023 09:41:32 +0000
Message-ID: <TYCPR01MB6993C08EEC0FF360E3FBC2A3E5B39@TYCPR01MB6993.jpnprd01.prod.outlook.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <TYCPR01MB69938E7E2E14697FCF166155E5AD9@TYCPR01MB6993.jpnprd01.prod.outlook.com>
 <ZADNdp5U+lP10Oqo@alley>
In-Reply-To: <ZADNdp5U+lP10Oqo@alley>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: ff6d0fd132924dafa0a2c744d7ccb1df
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2023-03-03T08:39:09Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=82e2b6b0-d393-4790-9a50-642ca0cdcd47;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB6993:EE_|OSZPR01MB9281:EE_
x-ms-office365-filtering-correlation-id: 4f6bfdd1-9333-4b69-f2c1-08db1bcb7a2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ptDNoTsamXCfx93jsdf55JPAAmg5RoeZVLAVEcdfIQ5SkMNgeBnLHyAxOCAYpDu+GmoNdB7n19j3u1p1iSccUE0cve0S9T4A9Syea26YOP2M2NRGXmZnEEhrRVKGEiNzpZ4k771F2c6UOPprzW32th+wE9Mi6JL7tiS2aoVrxFmnQMnf1lT43sd4xs3y8xuSzHq7BYGtZ1krKOyXclR0d1+XutxyBGDz07IWWy6/ZNZDY0IGPbQ+Ekm4S2q0q0XtT0/H5hMYI3Jcuk/QlbPqPZCSXosyzKcp0lReNUjuShbCbFt3Vm6sbeCCefuwXW7ZeEJCnhk5Qa5tHFj2sn3QUvga/6A0ZmFK3jlH1acwEGaOYkW/Sak7wxvC7J9eUPfz4t4otAsOH1MlX/8eKxbol64nNHGewKpcvGeWBhzu0QEiFeQel9k7ZLCqJW9hXBRLvbgmSN7Onp/6VnVh+qpBVteQ8Q9NggdMaE1PARNUGbvG11UP3A666Pt50X+B4cX7O9VzZLGcyL/xWocpi6pe48Xg3RXiVhKrNFvEexoEWoMcrv55v5ryMjm0QH+Bb28VBxQgajDvTYlliaNahYzU/9qm8AyU7uUp8L+ZjSpLhAUBnu2iJ1IA3KpwC+kmJmbiAB0WlcutlNCQOpIqtDlVWVK4lH/VHleGylDh8W9435MYxXfS55ZpzeFUeDxC+5pYzRMv5pBwsttD+tbf/DBminEBa+3qWbjB1kANdKPYvLd1Ls0Zae6ADmUE+Of2kWY4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6993.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199018)(1590799015)(1580799012)(85182001)(8936002)(5660300002)(4326008)(52536014)(76116006)(8676002)(6916009)(66446008)(66476007)(66946007)(9686003)(66556008)(64756008)(186003)(86362001)(33656002)(41300700001)(2906002)(478600001)(316002)(26005)(7416002)(966005)(54906003)(71200400001)(55016003)(7696005)(6506007)(38100700002)(38070700005)(83380400001)(82960400001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?YmFZUUhGOU1iVWQ0eFpJaEpoZytGQythOXQ5blVxNEcydE1paXQvNWRH?=
 =?iso-2022-jp?B?TUkzMDA0RGRxWnJsREVHTGNYRkJKN0E0eUQ0NGxSUkFPUndsblZJK0ds?=
 =?iso-2022-jp?B?UVNURVdhTnVUS0puNkdMc00zZXFpR0cxa3lCeEhKdWNYa0NyRkd3K0I4?=
 =?iso-2022-jp?B?SlJlYjFRZzBQUU03VGI1c01kYVMwc1BhK1NERUt4MzVFSEE4ZDIrK1dN?=
 =?iso-2022-jp?B?eWg1eHJ3NlVCeUUwQTJ5enRLaXdWZzBRaDFuZjNqMzFjb2xHbFNTQ3RZ?=
 =?iso-2022-jp?B?UFpmSHlkay8zQTd0UmUvclhjYnk5THFMdUZVVzFHLzNCUmdaS3FkMk9W?=
 =?iso-2022-jp?B?K2FHYkl2OU5lLzR3Y3NSaXVFTUFIQUlxUnA2b0JLTVFvbDN1dXZXWXBD?=
 =?iso-2022-jp?B?aXo5aVRWY3huMU45emg0dFV2MEJpSXJNbFZPN1kzTmgyUU9TTXJRR0xK?=
 =?iso-2022-jp?B?Wm5PMGZOcURmeWpEakdRYUpNaFA0Z1c4SGFzV1hOdUo0Z2xZYVhGRERC?=
 =?iso-2022-jp?B?VGszK3BmWmhOTkc3Z3ZNTWVWbVA1VVZNT0VTb1JQMmdEd1U4cm05cWJK?=
 =?iso-2022-jp?B?SkxSaFdocFhaMDI4N1dXNFVwaWZWa21SNnh4Z3F4c0NqMFZDZ1c2OFhj?=
 =?iso-2022-jp?B?UEU1SzBKUEVlcm4zOEtOZlF2VFZkMUVNR3lHbi84ZmFGWGVYYWRBa2hr?=
 =?iso-2022-jp?B?QjlsdkZzSVFZUXRRUHBYT0VIU3hFdStRRWZ2RzdZZm5MMXFhTXk3c1Jv?=
 =?iso-2022-jp?B?SHQ0ZllOanFxblQvVEdFdGcwNXhLQnA0dVBHT2h6aVovSWFSOXA5OWZs?=
 =?iso-2022-jp?B?RlM2djVrNW4yOHRnUFQ3Yy9WY0cyMGNoRGVwVDZaWU15WDJXOHk4Mm5o?=
 =?iso-2022-jp?B?SlNPZE1nSHRGQzkwT1dSeG1lRjNHV3NzVW5xK2dXb3lVcFVYdE1Gd3M5?=
 =?iso-2022-jp?B?U1pqVmZMTXlqcXQ3WnVDQnYyZUoreU8vaitoanBBNWgyMDJWZzRCK1dq?=
 =?iso-2022-jp?B?bFRRbGZDc1J2dDZTSFVQNmtLWFZXVm1XUXVtVVJrTFFEdWUzWlNxSTZY?=
 =?iso-2022-jp?B?dUYrblRDUGFKZSs5Z2pBbi80NTdGVUM0NWJPWGFBVmx4UmVoV2t0cmlD?=
 =?iso-2022-jp?B?b3UvMXhqc0tqOWZtWFRXem8wb05udi91enJ5aWJyd2dNdXE5RW9jdGtB?=
 =?iso-2022-jp?B?d3JUZGdjTE5uUUJKNVFka3hsL1I0V255cWJtMmcwVlhwUmdoSUFucjMw?=
 =?iso-2022-jp?B?aDQvdDd4WmM5OGkrZ055ekZZUklqOGpFSjFhNWtPWkdDV1c3ZzlJNVZT?=
 =?iso-2022-jp?B?bkJ5akNZaVlGMVZZbG81QmloSWlYbm5BSlpzRjFXNitBalRtci9TZGYy?=
 =?iso-2022-jp?B?QkxSR2xPM3lTTVAvZHNMRVBKTVNXazdLakY4M0ZtNFUzYU5GK1E1VlNt?=
 =?iso-2022-jp?B?UEpkcjdWazQzMjNJMnhEamx5c05xaXJNZDQwQitvaWwvUFBFc3J1ODJY?=
 =?iso-2022-jp?B?Rml4b3kwbnplRWcrdVl6RGdvSnpHVThPcEFHUDBUNWVydFdZQ0hQZVNs?=
 =?iso-2022-jp?B?UVVXRFRvajRJUjdHUm0wcGl4amJlMFZaZ1NkUmxteTBtNzA4UTQwMWZS?=
 =?iso-2022-jp?B?eTg1eStRdzZId1BQMmRUdDZTZm1Pb0VYZko0ejkyTUpMTGI1dzl2S2Zl?=
 =?iso-2022-jp?B?VEJJcWVKRjd3RlVObkdHTWJtWlR3cy9QZk1YYk1mTVczREl3eEtUakR1?=
 =?iso-2022-jp?B?LzNkRWVDbXBZNithS2ZqZEIwV1c1NnZ6blVXMFdzay9YQnBPM2FFOW9E?=
 =?iso-2022-jp?B?UlJGOE5scGk2SE5wR285WHJEeW5Gckd2Q3hPUmR1SXVZaTJwbHJGbUl4?=
 =?iso-2022-jp?B?RnhVRWVpaUpHQ1FBcjU4VVdxQkNpbmk5UFUzaEV6SmJzcVU2SEZZMytM?=
 =?iso-2022-jp?B?M3FHTytmb3pUWmlIM2NXaWNJZmNsMTdPYU9wYkIydEhZNUVPYndVbGln?=
 =?iso-2022-jp?B?ZlVLNVRqQ0ZlZ2RvbWhhWGpqZzdBRlFtSEpTYzdXTzRjNkZuejJySDgw?=
 =?iso-2022-jp?B?cUo2VFVFRHJyanBONXV1Y1N4cERabUFxMEJhaVVCYWZqZFNyR3kzOXhT?=
 =?iso-2022-jp?B?RUZsd1JOOXh5MEpCYlhQWFE4QVRjcjNMZTk4UHE1OXJFYzFTOG1sSDVH?=
 =?iso-2022-jp?B?bzhBZUlvdHVmM0RuZEJsWTd6b1N4NXAxN1BuV1o0c0Y1bnB2eGtFS2N1?=
 =?iso-2022-jp?B?TnIzZms2eklwaW1zNXpBdkY4VzBPSzNmRldXSlFOa2Jxc3A4czN5TVJV?=
 =?iso-2022-jp?B?OG83cmNreGdBeVN1L1hVaHExa1c5cklwNkE9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-2022-jp?B?Zy9GOVY1YmRocHhza3diTG9DSGxLQnoxNXB6eWlOMFlPOVJpUFVXRzlh?=
 =?iso-2022-jp?B?TFlPMEhsSWpuOUsyNVIzbjhGS0ZFeVhQY0NCcmhEazJWanpnNm1EVDJH?=
 =?iso-2022-jp?B?TmJ1S1diSDR1alViaXNDS1hhRkV3bU53MVc2d09GR28xaGhzNkxwNkpm?=
 =?iso-2022-jp?B?WmdsWDB3bTRmTkFVRW9iVjRsR25nRjlYZWdyMDJ2Z1lwaXZXZWRQaDBq?=
 =?iso-2022-jp?B?NENJek1zSm9sOE56Nmw5dnF3N0htMzAzWU5FY3d0aFk4b3FxUnFYbVJB?=
 =?iso-2022-jp?B?VmFMRmx5TndheXB1QkZqdnZjY1dpOUhIWDJoTGo3bnJxTXlJdHc1OUJN?=
 =?iso-2022-jp?B?NUhRUU04bUd2U09aNWF0MjRscCtXWkpHdHVGTk0xKzR4REFBUmVadHZ3?=
 =?iso-2022-jp?B?S2lCWU1PaHlsaFpISDhMTWNsclZjY0pReXFYa0Q0cU43RmJ3OGcvWmdz?=
 =?iso-2022-jp?B?UXVJOGxwaGl0czhEdTk5UWMxTmJydmNXaWlWOE53RlIrSnFDVXJITjBS?=
 =?iso-2022-jp?B?YWVOQlBoeUpLcDlOTU5nL0VVeloxQTdmK3BybnFPQzdUcjg2WSsramEw?=
 =?iso-2022-jp?B?SE1heVdya1pKWXc4ckdsMWJKMmZsd3E3eTJnQkZmbVladlhObWdoVXU0?=
 =?iso-2022-jp?B?Mkt2SUZHejFZMWxOa2QvdldZVzd2OXV5cmg4Sjh5TjR1aFZneDlLOEFh?=
 =?iso-2022-jp?B?RjFodEN1amxYcE9pbndzdk9FVWJYdGJQV3JzVHpTNWg0UXgxQ3ZnL21w?=
 =?iso-2022-jp?B?TEdqZkZxTkFwVWRMdTRtSzVRaWhxaW9KRFY5OEFDanV6TmlpQ2ptQWox?=
 =?iso-2022-jp?B?dWNRNDdrY1Z4YU1OZG9tWkpYQS92QUQ3RjYvcG5TOGIzWXl2ZFJCTkFh?=
 =?iso-2022-jp?B?bUNmVitwbGJ4VVQ5emw2RTU3RGgrdUd2K241SCt5dDI1MTU1ZUtGN3NF?=
 =?iso-2022-jp?B?UCtFZzMxUDc5Tjk5MXcveFVxZGlMV1ZScjNQOE5XdUpDenk2dmN3enhB?=
 =?iso-2022-jp?B?djllQXZrY1owNTMwUnY1N3lsR0lHeHRzc2piM0NEdjNncURZa0NWcnlp?=
 =?iso-2022-jp?B?RExkVkpGcXlnYlZRK2MwamlQdUxsQmR2dzVhMUwxeTNuYUF2TTF4a1Vs?=
 =?iso-2022-jp?B?NklULzhMVzdNQWhBUTRtNlNqNy9HaC9WVy9VNzh4OG5MZkRFWE1rSm9u?=
 =?iso-2022-jp?B?bm5rTmNubDJrVCtWQ0twVDVXRWNINVNxak8zd3pYdFJGRlA2Y09PT21x?=
 =?iso-2022-jp?B?ZituajNwU2hhclJzcm92NXFKVEtxdi9mYjcyR1RlNGQ3dmFJcDhzUHRv?=
 =?iso-2022-jp?B?Z09rTWd0Zlc1VlU1UXNDcGI0V3k3MG9TOWFUTjZyNHJtMEJ5TzczNHlq?=
 =?iso-2022-jp?B?ckN5cXlscyt6eU5ucWtrWENvRUc4NjRuVnNYWi9jb2diR1g0VlRkK1N6?=
 =?iso-2022-jp?B?d2doYjVSVk5KU0k4aElPUXFxVmgxRU10elo3dDR6UTV3Rll5cmh4WFlt?=
 =?iso-2022-jp?B?ZU5YSVBjVWUvRktpRHlEdktQWHcwS01XNmZ5dk1JQ2VTVDNQYkQ=?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6993.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f6bfdd1-9333-4b69-f2c1-08db1bcb7a2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 09:41:34.4574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5/WuzUioNDAYw3+ZGNRLWf8aBo+mI7E9PbmVWNukstELMsKZwRtYL/GTQ669rqGriWu4sF+PLwByEcBW5KHhPKSyjQGw9EwvA5ACz+RDI3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9281
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > <snip>
> > > Testing
> > > =3D=3D=3D=3D=3D=3D=3D
> > >
> > > - I have run all of the livepatch selftests successfully. I have writ=
ten a
> > >   couple of extra selftests myself which I will be posting separately
> > Hi,
> >
> > What test configuration/environment you are using for test?
> > When I tried kselftest with fedora based config on VM, I got errors
> > because livepatch transition won't finish until signal is sent
> > (i.e. it takes 15s for every transition).
> >
> > [excerpt from test result]
> >   ```
> >   $ sudo ./test-livepatch.sh
> >   TEST: basic function patching ... not ok
> >
> >   --- expected
> >   +++ result
> >   @@ -2,11 +2,13 @@
> >    livepatch: enabling patch 'test_klp_livepatch'
> >    livepatch: 'test_klp_livepatch': initializing patching transition
> >    livepatch: 'test_klp_livepatch': starting patching transition
> >   +livepatch: signaling remaining tasks
> >    livepatch: 'test_klp_livepatch': completing patching transition
> >   ```
>=20
> It might be interesting to see what process is blocking the
> transition. The transition state is visible in
> /proc/<pid>/patch_state.
>=20
> The transition is blocked when a process is in KLP_UNPATCHED state.
> It is defined in include/linux/livepatch.h:
>=20
> #define KLP_UNPATCHED	 0
>=20
> Well, the timing against the transition is important. The following
> might help to see the blocking processes:
>=20
> $> modprobe livepatch-sample ; \
>    sleep 1; \
>    for proc_path in \
>        `grep "\-1"  /proc/*/patch_state | cut -d '/'  -f-3` ; \
>    do \
>        cat $proc_path/comm ; \
>        cat $proc_path/stack ; \
>        echo =3D=3D=3D  ; \
>    done
>=20
> After this the livepatch has to be manualy disabled and removed
>=20
> $> echo 0 >/sys/kernel/livepatch/livepatch_sample/enabled
> $> rmmod livepatch_sample

Thanks for the suggestion. This is quite helpful for debug.
I did some tests and in short, I could run all livepatch selftest successfu=
lly
on clang15-built kernel when RANDOMIZE_KSTACK_OFFSET=3Dn.

Below is my analysis. Please let me know if I'm wrong.

When I checked the stack state while being live-patched, I saw some tasks
sleeping after system call are not transitioned. For example, I saw a task =
with
following stack:
```
sshd
[<0>] do_select+0x5cc/0x64c
[<0>] core_sys_select+0x174/0x210
[<0>] __arm64_sys_pselect6+0x11c/0x384
[<0>] invoke_syscall+0x78/0x108
[<0>] el0_svc_common+0xc0/0xfc
[<0>] do_el0_svc+0x38/0xd0
[<0>] el0_svc+0x34/0x110
[<0>] el0t_64_sync_handler+0x84/0xf0
[<0>] el0t_64_sync+0x190/0x194
```

Then, I noticed that invoke_syscall generates instructions to add random of=
fset
in sp when RANDOMIZE_KSTACK_OFFSET=3Dy, which is true in the above case.
Actually I see that sp can be modified in the binary:
```
$ objdump -d vmlinux --disassemble=3Dinvoke_syscall
...
ffff80000803076c <invoke_syscall>:
...
ffff8000080307b4:       9100011f        mov     sp, x8
...
ffff80000803085c:       d65f03c0        ret=20
```
This will set the instruction UNRELIABLE as sp value is not deterministic:
  https://github.com/madvenka786/linux/blob/orc_v3/tools/objtool/arch/arm64=
/decode.c#L173
and in turn will skip the generation of orc data:
  https://github.com/madvenka786/linux/blob/orc_v3/tools/objtool/dcheck.c#L=
313
I can confirm the orc result in vmlinux:
```
./tools/objtool/objtool --dump vmlinux
...
# no entry in range of invoke_syscall (ffff80000803076c - ffff80000803085c)
ffff800008030764: cfa:sp+0 x29:cfa+0 type:call end:0
ffff800008030874: cfa:(und) x29:(und) type:call end:0
ffff800008030874: cfa:sp+0 x29:cfa+0 type:call end:0
...
```
So, when live-patch is performed, stacktrace of task containing invoke_sysc=
all
cannot be validated in arch_stack_walk_reliable() and transition won't happ=
en
until the fake signal is delivered (unless task's state changes).

It seems that stack validation itself works as intended.
As I said, when RANDOMIZE_KSTACK_OFFSET=3Dn, selftests run fine.
Or am I misunderstood something completely?

Regards,
Tomohiro
