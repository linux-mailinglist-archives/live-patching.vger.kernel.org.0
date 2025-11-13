Return-Path: <live-patching+bounces-1849-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 112D9C556DB
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 03:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7006434ADC3
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 02:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2582F7453;
	Thu, 13 Nov 2025 02:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Mex3/ubV"
X-Original-To: live-patching@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012014.outbound.protection.outlook.com [52.103.14.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B5129E116;
	Thu, 13 Nov 2025 02:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763000727; cv=fail; b=KLugylCCVj+PWRJx5zsWEDgtDvfN3onnW49aQam9JRzW1XNBqBdQgJti4G8KdTN8nvgLqoZfA++QWYn+TBTrE1g/xImtIH6dT2iGu5OGcjgvnWv5mLhPYVcyblQoIkzo7SLAj7/tWE0R+/K8hqbpBuhfzhP0P7ArNOHx6VRBTtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763000727; c=relaxed/simple;
	bh=vkNSTuGT/P69ZWfWd7hDiRs5JY8iFFQwgZbJuJxFhLY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ns+UJCaNX8nq0CUu+OU07+LMF+4JH8MbCVUs7rhw/y1jipzNrtXfDaS6Kdghkqod5sOPcFB10I31AGy6Xk9OtmK/sWBevDHwDaiMr1d6wdBtks1JHwDGTRtymIiB71FlW4imHKTdTzq342URnF+ltw8eRJ8HiI2506+H5A+W6Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Mex3/ubV; arc=fail smtp.client-ip=52.103.14.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/ga6sNvMts7q4XMNeT1Xwdu7OUZ6FVVl+HJdskPP2FJN/xAFu+A68CSjJLa8kjUM1H1GmWu5ZBKnFXpA06C6Hy/cdpIxYi+8MT6P5ES5dq9PcXer90wb5qt2ukiCZ28OONee6wv+eziJgWKAb0i1L8Z68D/WIRxTEMC2ufS4NTp7oRqt5Yp1VQbEqhHKim9ciQiIO8Hey1SIi5TIKKfyuuHpV2iekNPZPrRWFpp13ZlaGlXUAw+R//zcOKmQsSmoeZTXrtfjG0+Kk9vtOUHGi2dZKoUD/r5uz3JffIxXWlMjkjwg5MAlWcQZN41eIy4zej2mCT+jmfhiAwfq+zuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PCVzzBd4Kpyi5CCeyQKo7JgHRo4hNdhqN1PSbBsDsM=;
 b=XFFMqqTF8e14+Mvu92x0K/K0VU77jxfxc6tOsqfDL3pAFYYntxLvJkWThbIlEkruw1E/BDyScK+I8oSVnKmooUOagpB7QHQHCnn34l8agEJuei6LzMO1v9u10Kp2OMIVKoxf0H7ngBAXwrsjDIINuRWPAHwH1mxq03tdF33oBeX3dUyo5MAQ7Meyj741iFJMG0F6V1BkdF0yKQOIFv0rZojhDeqU0u1tLNneTWVjqDnpk/2AZMOTJKdu6NomJpD/B+tRqCkWwQxdqvqTby2IN5ELNmfNokLcLaNu1wRrEKqUXXVAMowfb7XpGbeHyIRR368nrEzHic1Q/CbPBiI4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PCVzzBd4Kpyi5CCeyQKo7JgHRo4hNdhqN1PSbBsDsM=;
 b=Mex3/ubVDZe0hJ7p3/B+fT5iZwHijkw8T84OtGdzkWmX+RzaVCCugklUDy0xWC19ePFVa3EFhRghpKE6/HqWvE+do6ejX1DjNPec80E55u9PeV0gH5aWGqU+tD98AR8BsVq4WZWsAZgN8IStZDh+TG5mKcheqT88eqqD7Dd7N/i9KXzsgEzt6k2hMt1gonGHgVHApBZygP8EEnDIGEWQBqWZAq9kuEJuEgZosRoCaQSvPpTEL/rjcCj316J7Wfir4cmo89xP5/39UjIm7WZZ5kwqKcfGtYTKj4Zbsrg7djkDN8VEoV6izaBInKzEFAMe5t5XBHEaIOBSm0/p0rQhxw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by IA1PR02MB8970.namprd02.prod.outlook.com (2603:10b6:208:3ad::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 02:25:23 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 02:25:22 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>
Subject: RE: [PATCH 1/2] objtool: Set minimum xxhash version to 0.8
Thread-Topic: [PATCH 1/2] objtool: Set minimum xxhash version to 0.8
Thread-Index: AQHcVCym/quoEBXvrkKqM+A6yxpWtrTv4GZA
Date: Thu, 13 Nov 2025 02:25:22 +0000
Message-ID:
 <SN6PR02MB415759BAEC734282A36BB5C2D4CDA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1762990139.git.jpoimboe@kernel.org>
 <7227c94692a3a51840278744c7af31b4797c6b96.1762990139.git.jpoimboe@kernel.org>
In-Reply-To:
 <7227c94692a3a51840278744c7af31b4797c6b96.1762990139.git.jpoimboe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|IA1PR02MB8970:EE_
x-ms-office365-filtering-correlation-id: 83d9bd93-99d9-40b6-a941-08de225be5d4
x-ms-exchange-slblob-mailprops:
 02NmSoc12Dc43FlQvP2yewYSt45NTkBZSuGDr5ASXoodmOub4GvTwK4/8OylENO0LHGA/03CIitFTEJ+zDU+74iZbhNUSYVYl5kZqkck7hnCYiJjhNMxDRiIwCzK+hP0DV6WaLFVIDVJqqi9f1HwGCgyU+F+LNmBALucEJq6U3a0V1delQjr8iT5+oiElkHZ8zx37eJRX7UrbAcXWwaHeiO1tV1JnE2Xu1QT433pSo/d0d2P8YZZm1vKNdVvDCvW8ziy52lh7vKQJKfYpCS0nn6PjI186ESaM2m7NkQ+B3FamPGaBZDLIxwT3+nSfiIp1xSaVNYkz2fqHbpEjDfB2Up0AsuBU6wg4eQR6eJOyO8IFpngDPFgDqvDHVH2W7HNcqKv87sDZDSHc+UIYcq8n4iwiQAtPkmorM+VDGkpXLUcIE/o/ubMXqVcILUD4v2rtvRZlHSPlPsbLzYiYB5BJRQB9uB47zM4RbfSP3QbSITickmiL1SgyuiSUWpOw7XgkQNYdQd+yJGhC/AFCsv6ToDi0ELW69D3XPpTFOchcx+8v2N93JE5B8+NFuheZn1H0VufQHvKisYj9Qjschl/Jckv2Lq/5sXp1FoYnL10ogWEzNwgkOjD60K1B84sFRJYktfdh3R48McExW+8m1OK05No8jOg3U0bxnSX6BzLHbPO04h9qsyBz/t12h9T0qP3pUG9xQpGca0alua88SpbJ7LeYnWOe+g5+57GVPX8hlPTHKIOfXRSmRo3Fq/U9jIk
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|19110799012|8060799015|13091999003|12121999013|461199028|51005399006|10092599007|15080799012|8062599012|41001999006|3412199025|440099028|4302099013|10035399007|40105399003|102099032|1602099012;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?LO30PYCg5D8KKlphMtE4QYpXnojmu+86QdZQSx2SNdiNrmx4GLD1/fb+Pgf8?=
 =?us-ascii?Q?xQlqnODF9jCtJXTO1n2ERB0uUAFE6OMKzR48/WPsGnWtg1n8JuX91IC26Od2?=
 =?us-ascii?Q?2Tme9WhcWKWAGWi97GQiIhjdf/hkqxVZRxOd8LB3MrFPdKhjaN1I0eBzcIbB?=
 =?us-ascii?Q?kL5ZnwDBt6OK5Ccnvwr6JJCnTww3cHtBUh4VIYCewPbrdD5n0c2BIM94jOTi?=
 =?us-ascii?Q?gVX4FssMiLnBosIQ0wc/zesVKDWkCs2v267Tmop3LRAMHIofP/+fz3iSX5RH?=
 =?us-ascii?Q?86OcmNk3d/j7Mp1OmTSM5ggYQsPJwcU8uoW+iUbFw6PyP0iNBEzkYnagHo/j?=
 =?us-ascii?Q?++ElqYCrNmJ/yUQohupyytosFac3W9nzM4zjAZZXYTH+3UvrKFZ2tCz2TKau?=
 =?us-ascii?Q?IZDC2RA4bbeyW0lguusid+ZtLbh3yWWrSe4negzMX/LcXZlErLWiRAU3P+Ya?=
 =?us-ascii?Q?zsqKuMc5tuvRDizd7NyJoTU0JOzSK8evw9BL8VYtyksbsMlouEfb15dsWqqS?=
 =?us-ascii?Q?ENOsbDpHyT4RYsKrysaQK4Lqv9TP3nDAmOVWVpPnXGWto/XecqcU2WAtK2bD?=
 =?us-ascii?Q?OsvnTTXRxx+uMa2NfQ+i/WgUdIJgDqPzY90nSXFWigejNEsL2a7METEYUF06?=
 =?us-ascii?Q?elv9dLGcF8f3DEtK6tjcb6zwybcPP/0VjFTJPqtxCHnhFEqW2FWc3hQWrm77?=
 =?us-ascii?Q?dFjlpZlz9mvS2I46+fqR2OpJLEwmaHnpt50gwHozBPdrQ/TzkWntn++msLPZ?=
 =?us-ascii?Q?qOymOY3Vbju4xBWOO3OQ5LJUs4Uwj8YejrjeaKw4L81fXLRVG3YL9qWd3g8C?=
 =?us-ascii?Q?pHN1s+u7BYb5QZx73ZPxs15S/H/CxChRR6GFktHEUy3NkR7J0Vrtnq42Om2v?=
 =?us-ascii?Q?UHWDMkoUalQjijaY3myInvJ0RmPbQzUiGXgC0nWY2p+6YFTu5n7rf0aH77Eo?=
 =?us-ascii?Q?SP2Yc8Lh/+pdZk/W+Pp4h/M2ELAEKG27SFIe+QKtI6JWFu4nly7wFbcFreAs?=
 =?us-ascii?Q?LFIJwnUgcId8IeMbvT4cGuCkDbH+d+hRAdehVaOKg4pXbJbmx/hW2n4rAnCM?=
 =?us-ascii?Q?Dr0Mu+yoZqOfecW5fBvTrrrMdPtAEdvruDwGINhVp4WUge3Px7j18OL+S7dL?=
 =?us-ascii?Q?PQ9VawMq40A1f6wLTtjF8fXgPxLZut+O1EeDr1g4Fp/TjgcQrG3QK0ak3eNA?=
 =?us-ascii?Q?gUTS/Ol/hb04R8kUjFabK8LLYmIL9cHbD/SZ4lp3OP41t8mf1hkggSe/oAWg?=
 =?us-ascii?Q?ZMfaPrBrjlLzqIrmmuQ+jbk21wqF3tEFS/YCVjjfAavMre8KBblG1ledP1/y?=
 =?us-ascii?Q?t5HR6XFVTXcEPDPrK4Z3gztAvhj7Fw7gCPR7RUHt008gmmJZTm0o/JzCs0o0?=
 =?us-ascii?Q?ja5POU2aJI/27B2toyj9f6NHbb1RtLTvYF3BVCGcONrNIzQySEmSwFrTLmLC?=
 =?us-ascii?Q?1essuhd4Rml2scIXWyJoYkpXaozasb2T?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uAQ2hN4BioX9oz08p/rRM4WcqY6hj8a9a5ZLNCTBw5sv4oOPCoklT8lUEgBO?=
 =?us-ascii?Q?BDgfjQ6zqVT1XAmQaQk/14b3MXdiWQNs7BWYzbhnChNVSpkgwInYs0B5iE5H?=
 =?us-ascii?Q?KKqm6HMP1hlH6l+9M858QdJ9RxxInNTbycyetAY4f4wA2N2nVvXvc7BpioIW?=
 =?us-ascii?Q?W2RDHfkHMeGqQZJDZfClQtZccWEIqHBhIwDj4ul2LfFoESzFXk0/5rlz+tuE?=
 =?us-ascii?Q?fNxzaZa5y4PammTu6sV4rd9dWi8+6EjP2myk7PujjBarKjdXxQOSSPB0PmRu?=
 =?us-ascii?Q?347SbItV6+/mmTBnJp3nM8PwToMRIlGBE07+eeXIqJm3RFVRtTm8IHx3oz1k?=
 =?us-ascii?Q?t6W0Im++5eSMn8Ab/aY4DsapSZwNHvLwwgQHsb4KfKNbOWTcNf/T7znwIRDh?=
 =?us-ascii?Q?wK4c13qU8fvbelMFB4Q8b/kLIWij9yxJuW49f7CHnPa8nx73zYMwAUlISaen?=
 =?us-ascii?Q?L/TenmXK9A7gdOcSorywWpzKZHnxbH2TkvwMTabuJfJB6ucS9zXxW9GAVHlU?=
 =?us-ascii?Q?GUL+Rud4TdERpkialh7wlj14kQ/fwWShA6Q4iU3tIShY0hD/N/g5mHiyXoxV?=
 =?us-ascii?Q?Aqb8EJsKlVEuhf7joSrV/xa5IKYJC+PCAzxxJmTum23VxcQKy4GgyXeOt6Z0?=
 =?us-ascii?Q?DdEBgetSrK0CD9Zk99Hzsb/YbcNj5AtegEJCIT6R4j3WS47Xnasf3wjDMHvR?=
 =?us-ascii?Q?VBMJMyCw7ZKvjwhyq5MW1ZLCWdgLQXV9k1pBtwBW0QdNv71Gpjnw01DQIqd5?=
 =?us-ascii?Q?XqFTJ7BT08JRnwAPmCzS2cHxe2lWvBCzjkQxJ6ByEEp8gzIJ9v56P8q5N6LX?=
 =?us-ascii?Q?DfH3JVqqt0dl98yLcmIwNmVlOXlm7yM2eUs+YKssjHlzjNqzC9CpRS1863NV?=
 =?us-ascii?Q?oyfRGU3gygQ9z2SHuEo4F9WvQz3gqqkpWm23haxWeHEMEHYEHiNKcYlx6KIv?=
 =?us-ascii?Q?ixQG17E0Dia4sFyaSXhfOr9hHRPNpObF6ZilLwq7yeUmLCFXARgcxr4ShKg+?=
 =?us-ascii?Q?Tiyx9Pb7RgDfaO8mr7AoMYDBQeIG0x1yGisUrEfK9dlvW9D0StkCnjLIMjKs?=
 =?us-ascii?Q?HmsV50bibcPkh6JLyE3stQB6DDUPP0j3kXhKbsA9JkFND9EEwNepfoLGDxHt?=
 =?us-ascii?Q?tAhsKHLur9cHO4HQKkeinqR9w2RrFndZOX9gcwLMKG7Ytk/PANuKKchF0UnN?=
 =?us-ascii?Q?ruClcqfLatWT5Qrz5lzmekIzf8Me+gWcylvn2EPE8hY23vzO+9pD3G/V/5c?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d9bd93-99d9-40b6-a941-08de225be5d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 02:25:22.6041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB8970

From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Wednesday, November 12, 20=
25 3:33 PM
>=20
> XXH3 is only supported starting with xxhash 0.8.  Enforce that.
>=20
> Fixes: 0d83da43b1e1 ("objtool/klp: Add --checksum option to generate per-=
function checksums")
> Reported-by: Michael Kelley <mhklinux@outlook.com>
> Closes: https://lore.kernel.org/all/SN6PR02MB41579B83CD295C9FEE40EED6D4FC=
A@SN6PR02MB4157.namprd02.prod.outlook.com
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/Makefile        | 2 +-
>  tools/objtool/builtin-check.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> index 48928c9bebef..021f55b7bd87 100644
> --- a/tools/objtool/Makefile
> +++ b/tools/objtool/Makefile
> @@ -12,7 +12,7 @@ ifeq ($(SRCARCH),loongarch)
>  endif
>=20
>  ifeq ($(ARCH_HAS_KLP),y)
> -	HAVE_XXHASH =3D $(shell echo "int main() {}" | \
> +	HAVE_XXHASH =3D $(shell printf "$(pound)include <xxhash.h>\nXXH3_state_=
t *state;int main() {}" | \
>  		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || =
echo n)
>  	ifeq ($(HAVE_XXHASH),y)
>  		BUILD_KLP	 :=3D y
> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.=
c
> index 1e1ea8396eb3..aab7fa9c7e00 100644
> --- a/tools/objtool/builtin-check.c
> +++ b/tools/objtool/builtin-check.c
> @@ -164,7 +164,7 @@ static bool opts_valid(void)
>=20
>  #ifndef BUILD_KLP
>  	if (opts.checksum) {
> -		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev an=
d recompile");
> +		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev (v=
ersion >=3D 0.8) and recompile");
>  		return false;
>  	}
>  #endif
> --
> 2.51.1

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>

