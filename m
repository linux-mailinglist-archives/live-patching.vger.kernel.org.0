Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96ED691967
	for <lists+live-patching@lfdr.de>; Fri, 10 Feb 2023 08:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjBJHxy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Feb 2023 02:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjBJHxx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Feb 2023 02:53:53 -0500
Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com [216.71.156.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098137AE20;
        Thu,  9 Feb 2023 23:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1676015631; x=1707551631;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=HYTzE7p7N69tC182BLNa1Cvie3rWhLRllWdrjRjIyIM=;
  b=LyJcmADjQQ7GFUjln31dM/txiBYnESVIyvDOV93Srcb1zt7TJbhV60jh
   oLjhvXQY7X8nb3YA/SYWkt9v6xA4nook02n9MC9O2Vog+feClt7j+XYxW
   yvKfxG2vcPvstp3pFTzeGQlzKj5wDbmI5srbISL9GLPTlKMo3mPbv6LzP
   P1x3NPdPhGVRnCHAERupkgoSCiWPZq+OqPzRgm+bmS919xSRUCRbByB2P
   JAGjaW3i2hTrrPRmviek/SqK30BypNmB3PXLixaYLJPLYrTQdwcw/RETi
   A8ZKCjnsqdgMRABWLpLG25Wzh3OVFO47glsAo+1PUc3CnOcT+zGYE0eDW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="77112743"
X-IronPort-AV: E=Sophos;i="5.97,286,1669042800"; 
   d="scan'208";a="77112743"
Received: from mail-sgaapc01lp2105.outbound.protection.outlook.com (HELO APC01-SG2-obe.outbound.protection.outlook.com) ([104.47.26.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 16:53:44 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mntBxacRssk+sMnT9ObOdvbQRgrY1bo9ZMMXjEDJYNg8k5uw+3vWG5/b+ero/hP5y9XpsZSzBaeG3FzopdnjHIuM1odkSXysezx3n6wbM72zyDmFL7DKGSsaOvq+iV9HiUwMeYS19+AybiaHGpfbA430Ti4lxdZytNGP1GNNJdVDHoW7qp9ch1hBBbUpISVmdN39KRgcFalJo5g56atOJX7wAN5QeVqqWmaaPXkJqPNFGiFDi6t/V1uNIjUgjozZIVykxslpAyeGHNpBcy7Kpy9qNJ/sAnsdHTBOWoNzeQjfxoKVxgcaH+xRvQ2jOvLB8+666bhaxvkjidbCFvgVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UilQhqao+e4+zb+8r78yKQUhbrgOyQktfXBTI5MDrR0=;
 b=NDmBAIedaYyzV0BJTaYQPU0B+9/NKp703HgxUi6xtqyZ8fO5euzxb8Hw24usJao0ihu/KPfq14q30Yzqlyki4g4Ub1/bM3zTPZDj0VqakfbBqUTlV0L3zQo9bUI9X4tCvYuXJYmiT0akYLvI9loq+en2soF8K/cjkX+lk47iHO6hiUzQbgdzAin8VAPwKpc7iv7k5psVV774EdkPoT7W8puIrogF85n7CXyLCEDSan+2DyUPT25Obtrn+K2ay7UMWFJiW7x1UYwWz2+xEoUjtQWiMnyn5K/A9qKWYp8tGGgdZjirJFoyQc6EmI4lLY4H2USt+NG8WbztBEK+QhOX0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB6999.jpnprd01.prod.outlook.com (2603:1096:604:124::8)
 by OSRPR01MB11566.jpnprd01.prod.outlook.com (2603:1096:604:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 07:53:40 +0000
Received: from OS3PR01MB6999.jpnprd01.prod.outlook.com
 ([fe80::74bb:613f:b987:366b]) by OS3PR01MB6999.jpnprd01.prod.outlook.com
 ([fe80::74bb:613f:b987:366b%8]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 07:53:40 +0000
From:   "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
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
Subject: RE: [RFC PATCH v3 18/22] arm64: Build the kernel with ORC information
Thread-Topic: [RFC PATCH v3 18/22] arm64: Build the kernel with ORC
 information
Thread-Index: AQHZNtveUCV2c2fpq0OjrZzgzI3JnK7H1wLQ
Date:   Fri, 10 Feb 2023 07:52:26 +0000
Deferred-Delivery: Fri, 10 Feb 2023 07:53:14 +0000
Message-ID: <OS3PR01MB6999B3CBC7C807138C321003E5DE9@OS3PR01MB6999.jpnprd01.prod.outlook.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <20230202074036.507249-19-madvenka@linux.microsoft.com>
In-Reply-To: <20230202074036.507249-19-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 6fa26a594a7e491bbf57a2bcabd5b436
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2023-02-10T07:36:19Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=74a4fa8f-2ab9-402b-8e9d-3614dd8276e5;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB6999:EE_|OSRPR01MB11566:EE_
x-ms-office365-filtering-correlation-id: 0818f71b-fc62-446e-bee4-08db0b3becba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTQJSP8aQ2+Dz5Navl3jCySePeZmOHcRJxEOQEzphtI9qwuP4Yp/ge4iw+0uOngmluCUs4KPiKZSu7aiwW9HSgeTAqTEjt7D7oFbEWIl+xXMcug3WUp73xDJalpQFIYqIUj8wk0iMzCVPrTsbZ27yUDrikmX78xAYdC8yJJokIRoDauN6iEJ9A+vG4SaoOCEAhcBPFG/phlzQkcwacaaV0qMjtis1wCQCFx7yWdYaMFB1zM9MaWdN0RwJrdkZ/gxZqAj0ZtLrhCD/QD438t6QBdR2VtWzim0H1X4IxEhPdOnyJR2DbYkonzhPhNPVo6hInf7gcfSBQQ/BGEKFvbhCVo7DF8QxpK9+I0REbQEWLPfQ5D7u03p4WgMF3QTt3jzIoJ4G5qMNbU4zVsdyH7oghhGkSTkwnpF34Uz1KfepPRYTtf/+wKJDOf3lnsmcih2VVB5JULmtc5khEAsNdqp+RZKtW938MKvm2prbbH/X7iDcUYilfZ9FHm1NVRTUIV3IIX85omvdsCMM8P9FBO1jZRSZxxqvWHb60MI2ASlIHaHnx0haeFy6LTBj3xiRThQSbG63MxHiBk+QuArKbUOOacTQGIoNljXgAXNS2Irny+HAGfLx1vgX8uKGyDSdN/YL1ADNkiI32RV2OcEyDS3/O+gQWj7nJMM/rEXwsI5XPGDSAkXCbXgSQGWjjuk0Y73QfhD9hzjLBQsNRSglPP5A4GphGtV+1+kxQkYXPGCoZbRjYKPVVrkTdxs6FW7NlgIhKfuPXEdZII6TNP/BtmQ96z1L7WSgh9/I30oc7b20GI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6999.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(1590799015)(451199018)(2906002)(7696005)(478600001)(71200400001)(26005)(64756008)(8676002)(186003)(966005)(66476007)(66556008)(76116006)(66446008)(66946007)(9686003)(83380400001)(1580799012)(316002)(82960400001)(38100700002)(5660300002)(38070700005)(122000001)(7416002)(110136005)(8936002)(6506007)(52536014)(6666004)(41300700001)(921005)(85182001)(55016003)(33656002)(86362001)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?KzhLeWFwWGRZeVV5UVBzMVpsMFdZWXp0d1RxVW1seERBaWdGa255TkI0?=
 =?iso-2022-jp?B?aFdXUXVGakVNMXAyTk9xQWNxb2ZQNE9ORTlHZ0dpemYrQnQvZFZDcUZM?=
 =?iso-2022-jp?B?UHF5ZkxabDEzc1laTVBaNnQ5S1c1VXZydlFXWkdieFpqYVFjVFY5UHph?=
 =?iso-2022-jp?B?TWZIMThLSnErOUd3R3lLRWlXTFFPOW91Kzc4SFU2M2tsQVc0TVRHUUlr?=
 =?iso-2022-jp?B?SzJ6MGc4UXpHdktOV2o5NUszakJFQ0IwM0krc0VudFpBUzFxb0ZsVFFz?=
 =?iso-2022-jp?B?WDl1ZmdUc3Ftd1dGZWVzU1NoRFRsanRxQUZRcXB6NkszeGUweU9lNHJ2?=
 =?iso-2022-jp?B?c24xc1pTOC9jb29pa25GUVkxSTk2OGQ0Tk9yNE5OUVdZWEh2MkkvdnBx?=
 =?iso-2022-jp?B?YVhnWjZ2bjE1MDBHamVDRDNPM2ZpbmExM3ZyRDhEaGJDd2Q5bXJNclFB?=
 =?iso-2022-jp?B?ZGcvME5xQTFlMTdhOHl6YW8yci9hM2ZpL0VWRk9oSHRIdGV2T3RpV3Fi?=
 =?iso-2022-jp?B?bitkb0tHV1lwUmRHdXNqQmc2a3BUaVp4T1liTDhnL21VK3d0cXpMbTh1?=
 =?iso-2022-jp?B?Sm5abHpDNEpkOVNTeG9ZaEZMRENmakN6K1VZNmdkcUpoV1AyS2hZS0Yv?=
 =?iso-2022-jp?B?VkVYZVErejdZaC9RWXpudzJBTGlvSGxJQnlkaFI0UnRuRllURXhEK0ph?=
 =?iso-2022-jp?B?WVJIVzhENW1keVhBUWR6c2JrM01VbnpKc0N1STJpTkNFeURObXU3NTJI?=
 =?iso-2022-jp?B?SkE3TU1WQmx3MGRHaW1CbjAxUFZYVTU4UmJJRExxNEpLakpreGtuVlk2?=
 =?iso-2022-jp?B?MUVnaWM5VFZiY0NOcDk5cFJjekFTaHBDWGdORUx4UHg0UnViYjRObGdo?=
 =?iso-2022-jp?B?cWRya2k3ek5yWGpFOHlKMVRxTldXRWNyVlNqTXZsbDlJRGJhUXRZaFNW?=
 =?iso-2022-jp?B?a0U3ZldqazZaUElZRGhSd2xKRmY1S2Q5TWRyZDhJRXFtU05sSUEyUDZC?=
 =?iso-2022-jp?B?eFdybVdWbzdzaWhPWXRtNU1UTTBpYUZNcnJpZ3lhK3U2MXdKamh5MWRG?=
 =?iso-2022-jp?B?VWNJbjJ0TmZpbXVNQ2NYTjI0bDhlRlA2aEVveFNjVU85d2hTWDd1eWU3?=
 =?iso-2022-jp?B?K2ZUUC9sLzJnSC9CNktoMUZ0aXUyY0RiVmt5ZzkvZElPWUxlMllldDcz?=
 =?iso-2022-jp?B?Qk1LcWFNK25vL1lUN1RLZ0Fob015SUpRZS9GanB4b2c3UGdkTm1QeDJw?=
 =?iso-2022-jp?B?dXNGWkludVVjNEdwbjNhTTYrUmtwYnp6NUIyVkJ6Nk1TRWkzVXduN3V6?=
 =?iso-2022-jp?B?RUxyQW5EeDFaZE1wMG83aGpRbTl0MXk0RmhGOEdmOXpONHJ3MSs0R2NX?=
 =?iso-2022-jp?B?UC9GSmppTUc5UkpYZUt1a21oZFN1czJIclliVGJoazd5YVUwNlU3ajJu?=
 =?iso-2022-jp?B?VG5Eb1JDZzlHSW1oOGk5QzRUQlVJNzB3bFBnclpTVGpiSFgwYVR0bU9N?=
 =?iso-2022-jp?B?ejIrMldxQ1MvcFFkSkdlcTFiU1BVc3RUdkw3OGZTZmJCRTNPS0o5WUVC?=
 =?iso-2022-jp?B?a3poQ0pWRTZJblFrNzEvNFRaOTYxUDVVa0gwNzRqNi9PeERSVDVtWUti?=
 =?iso-2022-jp?B?YTVqMlJscGNlU1htRGhGcWxWbjRuNUhGWHFHWVdaMkVZRUsyZXFVSFc4?=
 =?iso-2022-jp?B?OVZaR1c3eVNQUVRMVHlMaU9kV1dVRFNtMHh1RDFsQkxhNlFUUlJWcGhM?=
 =?iso-2022-jp?B?SXNmOU42WmNxdk1WNlZSRjVObDJ3TUlaeUJyeks4T0JNZ24xL3hIcGhG?=
 =?iso-2022-jp?B?TmdCLzZSZ3JkNGhOVkhkd1JXYnFMK3hNZi9DZjNocFB6OW9mLzdVSDdI?=
 =?iso-2022-jp?B?elU3aElRclNZQ1FETGlWeEM2TW5nL1UxWXM2ci9oR3lReGhZNmNLejA4?=
 =?iso-2022-jp?B?V2ZhbE8xMW0xNTNYL1RhcnZXZ1Q5blRZb0l4K0JqMVAxRU5qa0wrWUJ6?=
 =?iso-2022-jp?B?Y3lTTHROaG02cEkwQWQ3WWxCaGZOVGJtVFR3cnI1Z0JnYmFFRHBNbXNu?=
 =?iso-2022-jp?B?OFprV2hBTU0vUEkyOEdzdms1QlhTTjVzdFdmOVBmTm9lUWpqbHVDRnoy?=
 =?iso-2022-jp?B?bVRPUnR1U1h6MTYzd2trQTNaaVlEa1pFOS9sNkdLQUJ4ckxuQlNMME9Z?=
 =?iso-2022-jp?B?TUdhRmNTWDJDWUUxWW5kZ055V2tRdTRJREtCY0hzbWJkVEZjektOZGlG?=
 =?iso-2022-jp?B?MFBzQW9UTzFpRHFzTFpWVjZKbXlyRnkvUi9TOHk5R053dFhyMEYvSzhK?=
 =?iso-2022-jp?B?bi9CbkJGUTBwUnVORHlCdWwxY01mUUtuS0E9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-2022-jp?B?RzkxZnk4Ti91ZW1vQ3Y4SVE0MktvZlR2Zm81amRIWCtISDkvblF5NlNF?=
 =?iso-2022-jp?B?QWhCU0ZBY1A4SUhmNXhaNG1xeUZLN0VNYzYybFovdGk2VysrS2Q0NFlM?=
 =?iso-2022-jp?B?REV1UFh2M1VjZ1FFWWlXd3pJTUZEcTRpbDRpMnFlY3JtSkVmcWt2aFJj?=
 =?iso-2022-jp?B?SURhcjN3cGRWdkxsZEQ3ZjZKaXdEUTh6U2JoSERjbjlpdGliSUNrMFlI?=
 =?iso-2022-jp?B?elpiek9iTnB2RWhUYVpVSkhNdGF5ckYzZWRLSU5WMzJla2JjekVlT1Nn?=
 =?iso-2022-jp?B?b2EvWTNQcE1xYmc0WHIxZGIyNVI2dDd1RW5uaDA1NTJkd0pjTVBCNTRa?=
 =?iso-2022-jp?B?NTFEQnVIK0Y0ODZqVVB5SG92OEtJeTh2dVdUd3dVSmdReXpiNFVsem05?=
 =?iso-2022-jp?B?UjlNRDArTUxtVUZxUTl4K2FlV1F6V3BFL1J1elBRNVM5a1FKdXhBUDlJ?=
 =?iso-2022-jp?B?MlNyWGhpQzhkcVZTY2hXR3oxanE3RjF1STE0U3h3a3hka3dDZ2xFL1Zk?=
 =?iso-2022-jp?B?VnZUa2kzYmM0NmJmMW9iL0h1OTlTSTB0alI2VUc1bnlFQy9PdzcxTjdE?=
 =?iso-2022-jp?B?MGRGQThEazRZTTBFUWpVQVRmeHdPNVlNbHFnaVRLYUxxdXVtaWpvS055?=
 =?iso-2022-jp?B?R3ppdHJ3TlJid0lxSThhVkwwazFubUppSWlDd09xV1o3QThTSDlqSnIr?=
 =?iso-2022-jp?B?cnN2MGx3Tm42aTJnUDE4dkZUUlhxV0RuNHVESHY1aitzelVhc0dhZG1M?=
 =?iso-2022-jp?B?SGg0VTZoSXRKMUIzLzlRUTRlTnRHQVFtakhOVTgvNWxWOUgzWkZNeUkx?=
 =?iso-2022-jp?B?S2ZZMldkQndxOXNsZFpLclB1QmpiOEx2Y1ZlZlpqblVhQXQyZFF2YWR2?=
 =?iso-2022-jp?B?T3p2YURpZklCVHFXMWk5U0JWQjJyRkJteTFqeHVNZmtFaFVxVGkrbnc0?=
 =?iso-2022-jp?B?Q0N2d0srNjRydy90RStYRW5zRjI2NkFURnF5a0VnL1ZOaTRTS0hHSHJJ?=
 =?iso-2022-jp?B?N205QkRxd0VCb1cxOWxOc2RneFlDekpCRnNQT1pyUWZVMFVWTnJMS1Fp?=
 =?iso-2022-jp?B?TlJUQ2lKY1VGS1JySHJGVjJ3SVEvVHRBbzVDc1RBL3Bsa0pTSGZ6c3ha?=
 =?iso-2022-jp?B?UjNOcmN3NnpjbUZTOThjTUMwalZEaDVJYksrT2JUYURxVjVRTE0vTUJX?=
 =?iso-2022-jp?B?SW9zRm1qeVUrM3lIWGZvUHQ4bWJMUDFiMWl5Tm9ST2ZmVDQ3ZnFzMXV4?=
 =?iso-2022-jp?B?U29uRFpzM0s1c3JrKy9tRG9raGk4UVlVQ0ZJSENmRlZwMFlvaHVBZFJF?=
 =?iso-2022-jp?B?UUZUTExtby8vb0t2MWJlZEVVRUpjZ0hnNGFYdmx5MVNjWWRnZWdza1hS?=
 =?iso-2022-jp?B?UFlRaFVhaTAxREtKQVNqUk1DUEJVb3Q1ekFrYXdhenByRWFVRGEzZkQx?=
 =?iso-2022-jp?B?MmREcDhYU2xtdExDaWRzbTlLUnVIUmNLbUNnT3lCOWgxM2xDWHM4YzRr?=
 =?iso-2022-jp?B?c25XUXl5eWRJTWVsSUZsNnc9?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6999.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0818f71b-fc62-446e-bee4-08db0b3becba
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 07:53:40.5069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BNhKcePug3Mk5llpy/KlGrVV8yPgDzyqpYZkeih93dOMjPpycMKMk6q0t72V347NmtghZ7WHMOmdYBFkCOwwB2zR2SoI+QEHYot07Rwolz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSRPR01MB11566
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

I see the following build warning after this commit (gcc12):
  ld: warning: orphan section `.init.orc_unwind' from `arch/arm64/kernel/pi=
/kaslr_early.pi.o' being placed in section `.init.orc_unwind'
  ld: warning: orphan section `.init.orc_unwind_ip' from `arch/arm64/kernel=
/pi/kaslr_early.pi.o' being placed in section `.init.orc_unwind_ip'
  ...

My understanding of the cause is that arch/arm64/kernel/pi has its
own Makefile and adds "init" prefix to sections by objcopy:
 https://github.com/madvenka786/linux/blob/orc_v3/arch/arm64/kernel/pi/Make=
file#L25

I assume these files are not relevant for livepatch perspective and so it i=
s
safe to exclude these sections by --remove-section or should we care these =
as well?

Regards,
Tomohiro

> Subject: [RFC PATCH v3 18/22] arm64: Build the kernel with ORC informatio=
n
>=20
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Add code to scripts/Makefile.lib to define objtool options to generate
> ORC data for frame pointer validation.
>=20
> Define kernel configs:
> 	- to enable dynamic FRAME_POINTER_VALIDATION
> 	- to enable the generation of ORC data using objtool
>=20
> When these configs are enabled, objtool is invoked on relocatable files
> during kernel build with the following command:
>=20
> 	objtool --stackval --orc <object-file>
>=20
> Objtool creates special sections in the object files:
>=20
> .orc_unwind_ip	PC array.
> .orc_unwind	ORC structure table.
> .orc_lookup	ORC lookup table.
>=20
> Change arch/arm64/kernel/vmlinux.lds.S to include ORC_UNWIND_TABLE in
> the data section so that the special sections get included there. For
> modules, these sections will be added to the kernel during module load.
>=20
> In the future, the kernel can use these sections to find the ORC for a
> given instruction address. The unwinder can then compute the FP at an
> instruction address and validate the actual FP with that.
>=20
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/Kconfig              |  2 ++
>  arch/arm64/Kconfig.debug        | 32
> ++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/module.h | 12 +++++++++++-
>  arch/arm64/kernel/vmlinux.lds.S |  3 +++
>  include/linux/objtool.h         |  2 ++
>  scripts/Makefile                |  4 +++-
>  scripts/Makefile.lib            |  9 +++++++++
>  tools/include/linux/objtool.h   |  2 ++
>  8 files changed, 64 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 505c8a1ccbe0..73c3f30a37c7 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -230,6 +230,8 @@ config ARM64
>  	select TRACE_IRQFLAGS_SUPPORT
>  	select TRACE_IRQFLAGS_NMI_SUPPORT
>  	select HAVE_SOFTIRQ_ON_OWN_STACK
> +	select HAVE_STACK_VALIDATION	if
> FRAME_POINTER_VALIDATION
> +	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>=20
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 265c4461031f..a50caabdb18e 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -20,4 +20,36 @@ config ARM64_RELOC_TEST
>  	depends on m
>  	tristate "Relocation testing module"
>=20
> +config UNWINDER_ORC
> +	bool "ORC unwinder"
> +	depends on FRAME_POINTER_VALIDATION
> +	select HAVE_MOD_ARCH_SPECIFIC
> +	select OBJTOOL
> +	help
> +	  This option enables ORC (Oops Rewind Capability) for ARM64. This
> +	  allows the unwinder to look up ORC data for an instruction address
> +	  and compute the frame pointer at that address. The computed frame
> +	  pointer is used to validate the actual frame pointer.
> +
> +config UNWINDER_FRAME_POINTER
> +	bool "Frame pointer unwinder"
> +	depends on FRAME_POINTER_VALIDATION
> +	select FRAME_POINTER
> +	help
> +	  ARM64 already uses the frame pointer for unwinding kernel stack
> +	  traces. We need to enable this config to enable STACK_VALIDATION.
> +	  STACK_VALIDATION is needed to get objtool to do static analysis
> +	  of kernel code.
> +
> +config FRAME_POINTER_VALIDATION
> +	bool "Dynamic Frame pointer validation"
> +	select UNWINDER_FRAME_POINTER
> +	select UNWINDER_ORC
> +	help
> +		This invokes objtool on every object file causing it to
> +		generate ORC data for the object file. ORC data is in a custom
> +		data format which is a simplified version of the DWARF
> +		Call Frame Information standard. See UNWINDER_ORC for more
> +		details.
> +
>  source "drivers/hwtracing/coresight/Kconfig"
> diff --git a/arch/arm64/include/asm/module.h
> b/arch/arm64/include/asm/module.h
> index 18734fed3bdd..4362f44aae61 100644
> --- a/arch/arm64/include/asm/module.h
> +++ b/arch/arm64/include/asm/module.h
> @@ -6,6 +6,7 @@
>  #define __ASM_MODULE_H
>=20
>  #include <asm-generic/module.h>
> +#include <asm/orc_types.h>
>=20
>  #ifdef CONFIG_ARM64_MODULE_PLTS
>  struct mod_plt_sec {
> @@ -13,15 +14,24 @@ struct mod_plt_sec {
>  	int			plt_num_entries;
>  	int			plt_max_entries;
>  };
> +#endif
>=20
> +#ifdef CONFIG_HAVE_MOD_ARCH_SPECIFIC
>  struct mod_arch_specific {
> +#ifdef CONFIG_ARM64_MODULE_PLTS
>  	struct mod_plt_sec	core;
>  	struct mod_plt_sec	init;
>=20
>  	/* for CONFIG_DYNAMIC_FTRACE */
>  	struct plt_entry	*ftrace_trampolines;
> -};
>  #endif
> +#ifdef CONFIG_UNWINDER_ORC
> +	unsigned int num_orcs;
> +	int *orc_unwind_ip;
> +	struct orc_entry *orc_unwind;
> +#endif
> +};
> +#endif /* CONFIG_HAVE_MOD_ARCH_SPECIFIC */
>=20
>  u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
>  			  void *loc, const Elf64_Rela *rela,
> diff --git a/arch/arm64/kernel/vmlinux.lds.S
> b/arch/arm64/kernel/vmlinux.lds.S
> index 45131e354e27..bf7b55ae10ee 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -61,6 +61,7 @@
>  #define RUNTIME_DISCARD_EXIT
>=20
>  #include <asm-generic/vmlinux.lds.h>
> +#include <asm-generic/orc_lookup.h>
>  #include <asm/cache.h>
>  #include <asm/kernel-pgtable.h>
>  #include <asm/kexec.h>
> @@ -294,6 +295,8 @@ SECTIONS
>  		__mmuoff_data_end =3D .;
>  	}
>=20
> +	ORC_UNWIND_TABLE
> +
>  	PECOFF_EDATA_PADDING
>  	__pecoff_data_rawsize =3D ABSOLUTE(. - __initdata_begin);
>  	_edata =3D .;
> diff --git a/include/linux/objtool.h b/include/linux/objtool.h
> index dcbd365944f6..c980522190f7 100644
> --- a/include/linux/objtool.h
> +++ b/include/linux/objtool.h
> @@ -31,7 +31,9 @@
>=20
>  #ifdef CONFIG_OBJTOOL
>=20
> +#ifndef CONFIG_ARM64
>  #include <asm/asm.h>
> +#endif
>=20
>  #ifndef __ASSEMBLY__
>=20
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 1575af84d557..df3e4d90f195 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -23,8 +23,10 @@ HOSTLDLIBS_sign-file =3D $(shell $(HOSTPKG_CONFIG)
> --libs libcrypto 2> /dev/null |
>  ifdef CONFIG_UNWINDER_ORC
>  ifeq ($(ARCH),x86_64)
>  ARCH :=3D x86
> -endif
>  HOSTCFLAGS_sorttable.o +=3D -I$(srctree)/tools/arch/x86/include
> +else
> +HOSTCFLAGS_sorttable.o +=3D -I$(srctree)/tools/arch/$(ARCH)/include
> +endif
>  HOSTCFLAGS_sorttable.o +=3D -DUNWINDER_ORC_ENABLED
>  endif
>=20
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 3aa384cec76b..d364871a1046 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -252,6 +252,13 @@ ifdef CONFIG_OBJTOOL
>=20
>  objtool :=3D $(objtree)/tools/objtool/objtool
>=20
> +ifdef CONFIG_FRAME_POINTER_VALIDATION
> +
> +objtool-args-$(CONFIG_STACK_VALIDATION)			+=3D
> --stackval
> +objtool-args-$(CONFIG_UNWINDER_ORC)			+=3D --orc
> +
> +else
> +
>  objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+=3D
> --hacks=3Djump_label
>  objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+=3D --hacks=3Dnoinstr
>  objtool-args-$(CONFIG_X86_KERNEL_IBT)			+=3D --ibt
> @@ -265,6 +272,8 @@ objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)
> 		+=3D --static-call
>  objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+=3D
> --uaccess
>  objtool-args-$(CONFIG_GCOV_KERNEL)			+=3D
> --no-unreachable
>=20
> +endif
> +
>  objtool-args =3D $(objtool-args-y)					\
>  	$(if $(delay-objtool), --link)					\
>  	$(if $(part-of-module), --module)
> diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.=
h
> index dcbd365944f6..c980522190f7 100644
> --- a/tools/include/linux/objtool.h
> +++ b/tools/include/linux/objtool.h
> @@ -31,7 +31,9 @@
>=20
>  #ifdef CONFIG_OBJTOOL
>=20
> +#ifndef CONFIG_ARM64
>  #include <asm/asm.h>
> +#endif
>=20
>  #ifndef __ASSEMBLY__
>=20
> --
> 2.25.1
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
