Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9626E6A6661
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 04:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCADOd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Feb 2023 22:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCADOc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Feb 2023 22:14:32 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Feb 2023 19:14:27 PST
Received: from esa20.fujitsucc.c3s2.iphmx.com (esa20.fujitsucc.c3s2.iphmx.com [216.71.158.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BAF37B57
        for <live-patching@vger.kernel.org>; Tue, 28 Feb 2023 19:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1677640467; x=1709176467;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=tYIEo92VFTRQbHwcL/3QPPwhQ4JfOPNYU+tAkvIamho=;
  b=P2pWO6u3mEjZMAhIkhtceHE6rSWsTEastdXjEM0hjU2PGAJDq8QzWovH
   7TopsCnhlRmDgb4joItty0/0DoQD6bzDXLnPDMkIjkdSFIiS65RSD8Fl/
   pmgqQcJnKfhGoyroYYhqqmeNFKaiMGNISrB5TtIFPdqmfYD80N6Sms+0a
   Y+GcB+2RfQ3CgG3OxF+HZZo+ek01knoyOT0Gk26R5ndU/rf0KDWh6474W
   IZ0Xcs72ONvKcEPP5J4cfcaaXD798v0Qp9RYLAtGthHrFTlZp6FApXiCr
   1eNTIbKCCDTg5gfOM3TagB6xSbSkBXa4Ps17GdpOmSXjvW3rdoeTUYsxE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="78042999"
X-IronPort-AV: E=Sophos;i="5.98,223,1673881200"; 
   d="scan'208";a="78042999"
Received: from mail-tycjpn01lp2176.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.176])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 12:13:07 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAuQduEo3rKk/zxRyc9vvHjUMQKbtihzuGm5nhZzWD3Jej6YbR5J7mRGagq6GwEh0Erjt9A+zEP1uSb/1Tzmr5tIxp8tWRkIDFnf7bWUhzUhx+ggh+wdM5eBYVT65FEuZzrXHYj6gQdKR6IEjJI44fguK9AU2PSg5Too9X9wGSvKzQXvnBizq05v+Fshuv80dk6ZP9errscU1DG/YONw1fdzYcs7/s9AO8tCe32rn6lWh0ihmDCEQHyKmQZHmxtnpo9m/wudC3lryt75Kk2gvavoOgUihonAnfsHgYT4xKgjWHlND/r/be8X5Pk7ovdxvbxMwt/6ud9xtpDKn0rwsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/+B2JSV/0zwahE13ocFR7cq/8eXhTcOb/iV9hEyydI=;
 b=KrGNFFEMGKp34iq82dP8fbRjTYZbSUh1qvpaYHY2ZjSLbA4rlDP6utcKkr5VprWTpvnGTgK96coUEguGZyfYP1QAGYZphXGwEWN9uwv8MQBQzzYJqVoGLb9Rl2ZKoBZ69k8h3WUkc0uQlaZPdd0JTijEw7Jb6zG1Mhsy3dTsFyol6/Jga6nzXBkbffZ3XpiXVFWMf+OrRV5dOWTBqwhQQ/bttEQUr+qLIuV/PXtk5Q3VShvHUfRK/JDhUFLlz1Wehm+M1Ov9TL92HPSIQtkRwsEDH5JFXf8OsGvYHbnW+hS+Y+IE1Oky1abY9HfhnR/xgk/l9ERV7udWYZRIHZQ38w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB6993.jpnprd01.prod.outlook.com (2603:1096:400:bc::7)
 by OSZPR01MB8417.jpnprd01.prod.outlook.com (2603:1096:604:16f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 03:13:04 +0000
Received: from TYCPR01MB6993.jpnprd01.prod.outlook.com
 ([fe80::fa28:794f:a1b4:8e2f]) by TYCPR01MB6993.jpnprd01.prod.outlook.com
 ([fe80::fa28:794f:a1b4:8e2f%6]) with mapi id 15.20.6134.031; Wed, 1 Mar 2023
 03:13:04 +0000
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
Subject: RE: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Thread-Topic: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Thread-Index: AQHZNtr2MNh0z0iEfEuTLgtmunaVUK7lZbhA
Date:   Wed, 1 Mar 2023 03:12:08 +0000
Deferred-Delivery: Wed, 1 Mar 2023 03:13:02 +0000
Message-ID: <TYCPR01MB69938E7E2E14697FCF166155E5AD9@TYCPR01MB6993.jpnprd01.prod.outlook.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 17a89900d8a24ac3b697d27e33162ca5
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2023-03-01T02:58:35Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=733c9dc2-0864-4d02-a04d-1f76adbaefc3;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB6993:EE_|OSZPR01MB8417:EE_
x-ms-office365-filtering-correlation-id: b726163c-3f4f-4fac-6e56-08db1a02df42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: En2ypgOeXRhJcPGXXXsm0RwSVgkye8Rt5x0UAvl1e4gWsAXoeKTIqqvsMNZ3pQEp7ucb2hWsWXmBIaCrtOo0lHL5/CV3V5szwE7s3SDJ8k0uSkHjGgnVWqyXDpDveSoe+/VFuVblS57uCJVI5h5y8vW2qTwGZoH+QU0+DsjIriqCIDQ/Zvk6nGt1D/fyp1ZeGBQbVvtNUcHgfu10qOJx4c4UUQoAXPwr1v1VZrMk+Hy66awyG2Z4xgGpaZwopcrrXS3ChETIaTcA1Pw7hw9iXbtV7T6epW4OLoupkzmzC8+2cUAI6Tv46DhNhLjRvm6nnTzQV4d7Hdtd7D+tTPZsx/jGH9MhWvnGWN5e6MNC4t007juSAIWe/cF3Hn1y234gAunUFfpgVsSIi3+1YO2ryCC/aSJkofLyTuQ/qx9/EmfLQUEsdB8SKWZEf+r6VQMh9witPQz3bjrqDY1Dm7g2RvRvASwauG59/phjq4a+/SsCo69h7S+tcwRIXJL/ECuWwPTtD8L/vAZ109tGsPDy7dCT4nhm3yIbGXsdTfg5M8t1x2HTE9s1Q4XK7Pmf66Uss1Fp0QWMN004hA6puqFdqqgVooXpo09wezIBLjLOm/nF0+1q7Zp77XJCylr46Cz/Ov8G5Zxkblva+rb+e2/L3AEIaKQDX43uSie2ayikKZHe0JkiVDDtlUPT6XLRwzJE8neBKhL1X67KbdU1ygE/fddzTcbAZvS9zYQhC787ni4vKpvnREuIzIrrSgVGh7LuOE+EhVzPqfl340PuG6MxfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6993.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(1590799015)(451199018)(1580799012)(85182001)(66476007)(8936002)(66946007)(64756008)(52536014)(76116006)(41300700001)(66446008)(66556008)(2906002)(7416002)(8676002)(5660300002)(33656002)(122000001)(38070700005)(921005)(86362001)(82960400001)(38100700002)(71200400001)(316002)(7696005)(478600001)(55016003)(110136005)(9686003)(186003)(6506007)(26005)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?bmx2ZzBtK3dsdUt4d0NnTVE4V3ZWL3MxMTFTT1g3VG92cEJidlQvR0o2?=
 =?iso-2022-jp?B?YWZSVUhDSVFiWTJRR3VTbVJhVWJma2p5QWdXbDZGd21kbUY1MXhpS3VQ?=
 =?iso-2022-jp?B?d1BCSEZkRm5HQTBSTjRXMHdmczllN3dtNUJQYlg2WXN3RlREblFkVUx2?=
 =?iso-2022-jp?B?V04zZXhTd3ZYd0g2eUo1THYvN0tSZkQ4VWkreEsvWDZsTUJ4VWM4T3dF?=
 =?iso-2022-jp?B?VjJmUEhpMDRwd3RtTFpkUEl5bXZaQzZVSGV2V3pSMU9TcWUvWjFvaTht?=
 =?iso-2022-jp?B?and6Vi9sKzZ3M05scUF2V0N2VEpqTDJ4Z3NhenY2dlh0WkVSbnRXbVdR?=
 =?iso-2022-jp?B?Wkt0L1NJNmlrMmhzeW05N3NvQU1zNm51NExZZWtnTUVVa3lwQTl0MEtS?=
 =?iso-2022-jp?B?RlNsTzF3cDZ1allEbHIxWTBiNDlBSUphRTFBSkNnMVhYWkpkaXJwR1VS?=
 =?iso-2022-jp?B?ekxyL0dTT1FDcktldE0zaU9rWm9NUGtvbjF5SEIvVHlZZmE0QzU1NXo1?=
 =?iso-2022-jp?B?UWFXTmpJMXVJcFY3R1BJOXlEMWZJSmNuWlM3UFV2TEF6ZE1kdHZWYWs4?=
 =?iso-2022-jp?B?Mm0xamJjaHVEc21NcnZvZy9URml6RWxVbWRBQ2tVQ0pNVVVyTXR5MG1G?=
 =?iso-2022-jp?B?ajd3YVJPRVdXWlJ3citNUXV4Zm9ORi9ST0U0TS96VEJXRVFraXdaQUQ5?=
 =?iso-2022-jp?B?UGtpVnN6a1ErNXo2TzYyRFJ3cEhuWitkNjZKWkR2SG5MNlBtQjJ6TTRk?=
 =?iso-2022-jp?B?dGlIRWx3NUFteS8vNVFyV2x4WkpwM2owWGhFZUJSUGR6QXN2N2M3em1s?=
 =?iso-2022-jp?B?aXZpVTJiTUNmVCtSU0dRWDlKTDg3Rzl0U1Z2dEw0SklEaUthTkhWdGZ5?=
 =?iso-2022-jp?B?TFF4OEZTK29aNXR5ZnVieU8wVjFmbjluTkhNT0QzZjJlQjJrM29wU1JP?=
 =?iso-2022-jp?B?TmVOcXNxaitQMHdRKzFxQ3p2Q1YzR0RZOWwyQkdzbld0OFlhcUdLdHY5?=
 =?iso-2022-jp?B?c3dHMmtER3A0TTA4ckdTNC8rR05pcUVNV0RYTmtpcG9UUWdpUW1lMXhB?=
 =?iso-2022-jp?B?T2Q5RFEwSWNoNkJ3RUxRU2ZIZ1RBVlptNDlaQ1RnNExCeE1sSS91TEtS?=
 =?iso-2022-jp?B?b1NIdGFmRkRuVTNaV3dEUUJzTG1pUGt5QTloVFV3dFFzbzMycEsyTExO?=
 =?iso-2022-jp?B?WWoyVml1Tzk3bEpzUlJRYjM2WmJrQ1liK3Y0WXNEMmRXRTNFSEx2d0t3?=
 =?iso-2022-jp?B?Skw0c2pHb3FXdWMrVjlxQlFrQ0dENnNET3VxVGJHa1ZRSkFZZXNMcUR5?=
 =?iso-2022-jp?B?Y0p0MHpvNldjdkhyVUNyTDlzQlJXNkVraXd1WU1SbnY0VmJybjVCc2E1?=
 =?iso-2022-jp?B?R3A1L2hLUmloQXdRL2ZZbitoNE14b0VYT0lHZEErUjNkcmxJN0NhOS9h?=
 =?iso-2022-jp?B?Wkc2eU93bDdORWhHZFFnMHduaGJxakEwcXZqODhhU3hRSmF1MXVSeCtl?=
 =?iso-2022-jp?B?Nm43ZTJHcmZVbnBQS09lMVpOUnZWampjUTRvczhJWVQyOUtKY3ZocUk3?=
 =?iso-2022-jp?B?UVo3TUh3UDdPZDRtWk5TNDIvNmdSQUVZaVNzdFYrYkxtcEk4Y1JvaTNC?=
 =?iso-2022-jp?B?YW1qUE1jaEJxUEMxTjhPL1IvaituTUhDcFpHZEdxdHJRUlI3eHU2TWRY?=
 =?iso-2022-jp?B?a2pkbzZRamdWTGpJQzZYQzZycFBrQVc1QjY2YjJ1dnU1cnlZZ1FjUkQ2?=
 =?iso-2022-jp?B?TDV5dm9YVG80ajZ1Tzl6MTFzQUhHSUhVeS9uM1dnNVNESUhpVmRTeFdQ?=
 =?iso-2022-jp?B?dnMzNWVlOXBuMy9OU3dEaDhvWkZreFJpSlF4NGI5RlBrdkozcEJPSWYr?=
 =?iso-2022-jp?B?N0F0enlWK3ZJUW5Ib0FldGtMWXExaEYyU3k4SExCWnNUWmhwd3pIMkp2?=
 =?iso-2022-jp?B?ZXBOZmtlWVlGSDdnOUN6QkRwdk9uSmFZTGV4T3VxUkM1WHNBTWNNV01s?=
 =?iso-2022-jp?B?NDFsNEU3dTU4dytFMy83QTV3ZlN5bkJIOW4wS3dEdlBSWHVWNFdoSHRI?=
 =?iso-2022-jp?B?NndGZ2ZoWFB0MXpkVzIyUWJoZFJoZEVOdWduYmVROXlDd3RBNlNBNmVB?=
 =?iso-2022-jp?B?cHhmTFBNK1YrY3Z4bG9BaTV6Yjg2ejhIVXlYVXN6ZkxXdGlnaS91V2dF?=
 =?iso-2022-jp?B?NUNJblRqL0JXRDJBSU91dGpIVEJjd2dnZHZidXZEQVBSR1V4YXFlRlU4?=
 =?iso-2022-jp?B?RWZSSk1heVErY0JaVDBvYVZMQktUNS9SQ2JYZmp2WEhIYzZ4VWdYM1Ix?=
 =?iso-2022-jp?B?aU5jQUFBckFQejF2V3ExZ2dseUcxOVpGS2c9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-2022-jp?B?UFBiaWdncTRjRkNwanpOb0ZFT2VBb1drUERTZmxLYW1HbTBQNFg5L08z?=
 =?iso-2022-jp?B?Wk83SnZqRnJnb0NZaUVZb3Y5QzNVbVYzRGJxa3ZnZG5uWHlGVDRoMzBh?=
 =?iso-2022-jp?B?Y1VuUGU2bUpSUlQ4Y1pyNFR6ZEw4V21CbG9qYmt0bGU0RWFxUDZHMkVN?=
 =?iso-2022-jp?B?N1pCNDVnN0FaQnNOYkFiREErS0JaL0tmWWh2cDZqbkF5a0srM2pkZXBi?=
 =?iso-2022-jp?B?YnpTNDlMK3ZVaXhFOEN5bFV2NTVFdGUzZmF5THdFZytPWlY3dy96d1By?=
 =?iso-2022-jp?B?cTVGSks0UFVxQXRqbHZWdSs3SVBYQUFFSkVXQ3JwMkh6aEJpeTRIU1dP?=
 =?iso-2022-jp?B?UmZHWEE5UWowWjlGcmNBNFU2UlZoSm9SS2gzUjRoR296RHVzZWhRZGJl?=
 =?iso-2022-jp?B?eTVTejJoZVFhdWZwUWpBMFJsSElRNWxYS2NFU21Wam1MMElZemJYdjQ4?=
 =?iso-2022-jp?B?TG92bkJLUzZZa0VKRW94MndEeEhiaVA4NzJFUkw1UHg0d0RtbURoZ0hO?=
 =?iso-2022-jp?B?ZVpTdGRoQjFEdHAybGJkZHZVR3dzYkMyZVdaWk5zVE1hQTRVOVFTaFEy?=
 =?iso-2022-jp?B?eVAzT09xQmR0aG9yVFV4RmZiL2VXZTVDU0MraW1ISzBMb05helNwT0Z4?=
 =?iso-2022-jp?B?VGkyZGdGeDdkMEVDUU9ORzBwMUtZV0V2dmN2V21OWnVscytTQ24vc1Zq?=
 =?iso-2022-jp?B?S0JDTE1zN0YxeDhaMDhjN3hpejJwOWh3cmdodnFERXBkQTZnWVlEMTZS?=
 =?iso-2022-jp?B?OTBQRnNacmc0d3ZiNFV6ZFhMVUJielZVMDdHaE1PR3VxZ1lFVE1BZ0Qr?=
 =?iso-2022-jp?B?TXRUTnF0YjhRaUxyRHNyN1p6UkJvQkJyb2RSRm9xUndnQjRQQUVnT3o0?=
 =?iso-2022-jp?B?bnpFZ1V6RlRuVHpBNmhKbzlwL0M5YWNnRnJtWXdGK0ZNS3J4Vm5xWGZ1?=
 =?iso-2022-jp?B?VEVFZGR0NnZtNnFVSklMTFRVWERGdWYrK2lwOUpRQTJqVENRMlR4dmJa?=
 =?iso-2022-jp?B?WWNnUnNLVXBGZlVMbFRUN09HaXR6TDFFS2pNeW00Q0lTaE1zNjZ1dU00?=
 =?iso-2022-jp?B?QWYxejJ0djdxNEY3MFo1d1d0UjF4Q0hicDhVLzhSbXAyQnBYVEh5amJV?=
 =?iso-2022-jp?B?RVBHQ3BBb3lBdDM1ZFMxT1YyMHhEK3lpdjJ6UjJjcnl2ay9nci9PdmVG?=
 =?iso-2022-jp?B?bVVmTHo4UlNWZmhtMDM1TlZ4ZXhkQUNSaUIrazM0cmp3VU11U3d5NVFZ?=
 =?iso-2022-jp?B?c2R5bU9oN0kwa25XWGExREVyUmtxY3JqejFrOTNTNnEyMHIrbnJwUFNv?=
 =?iso-2022-jp?B?OEdYUnRCSFovd2doUXVCVFZqSDQvSmg3aGwvZkc3dnlJZlQ1SlVyUm13?=
 =?iso-2022-jp?B?ZUNyRFZrbU9QT2JDMFpDdVhJOHJ4T2FzcWxBeFQ2aXJ0VEUyKytYQkk3?=
 =?iso-2022-jp?B?OHhCNFE0NWQvditvRVA2Q3FPR2dWc2lDb0Q5VHBHaUI0ZzhudG55ZkVt?=
 =?iso-2022-jp?B?bnF4UE9GaDNNREpGeU9jcTg9?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6993.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b726163c-3f4f-4fac-6e56-08db1a02df42
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 03:13:04.0674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z/3UbUglQtS25nv46Pbg0EyGyBEs0ziXoDw18P5Ejlr+ztyH+tzbWPwQCA6lIG0Yi2x8KCc54Iq3RP97XA2qED2JRIScAu9TmJrbG2sBJ8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8417
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

<snip>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>=20
> - I have run all of the livepatch selftests successfully. I have written =
a
>   couple of extra selftests myself which I will be posting separately
Hi,

What test configuration/environment you are using for test?
When I tried kselftest with fedora based config on VM, I got errors
because livepatch transition won't finish until signal is sent
(i.e. it takes 15s for every transition).

[excerpt from test result]
  ```
  $ sudo ./test-livepatch.sh
  TEST: basic function patching ... not ok
 =20
  --- expected
  +++ result
  @@ -2,11 +2,13 @@
   livepatch: enabling patch 'test_klp_livepatch'
   livepatch: 'test_klp_livepatch': initializing patching transition
   livepatch: 'test_klp_livepatch': starting patching transition
  +livepatch: signaling remaining tasks
   livepatch: 'test_klp_livepatch': completing patching transition
  ```

Thanks,
Tomohiro

>=20
> - I have a test driver to induce a NULL pointer exception to make sure
>   that unwinding through exception handlers is reliable.
>=20
> - I use the test driver to create a timer to make sure that unwinding thr=
ough
>   the timer IRQ is reliable.
>=20
> - I call the unwinder from different places during boot to make sure that
>   the unwinding in each of those cases is reliable.
>
