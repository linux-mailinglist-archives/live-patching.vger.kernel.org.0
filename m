Return-Path: <live-patching+bounces-1832-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95954C366EF
	for <lists+live-patching@lfdr.de>; Wed, 05 Nov 2025 16:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72ABC62364F
	for <lists+live-patching@lfdr.de>; Wed,  5 Nov 2025 15:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C112DC321;
	Wed,  5 Nov 2025 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="QwTeXWUX"
X-Original-To: live-patching@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazolkn19010005.outbound.protection.outlook.com [52.103.13.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA2E22D9ED;
	Wed,  5 Nov 2025 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.13.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762356184; cv=fail; b=TD/847q6ctXZnTBQB6ZbDHKyS2Jmsv7RT33RCjRlNtpBB6RmJZz+ClCCdQTnXkWkeeSEwK+pErV+tdqmOZF0ZZecHWFmlZlIsuuAO7WC+dgYfNWyWY0ZyGf5/u4ehdMybFxE9gApvLUk+Ck7WMOjTdOkeSQd5m3lX00zntiKcwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762356184; c=relaxed/simple;
	bh=7vi2J64LH2wLvKs6Rn33WnPOoJe7QwMfRqY88orm1pQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nzOtfrSxQRqHXzJIAnArJpmPiNft/pVmhyoZYreHuBtIIXn+a9vF+aQuEbOYZkzKdf1IyZ4Dd4S5FMu7q7tSd9Q5gLe6AaZOSOJsGUcmh0FWVy+I7HziNl/6c/qh/hZ2im5o9l19rHMvIaO8jWHNluYb0mfiXZ4fFmRLR8+NEkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=QwTeXWUX; arc=fail smtp.client-ip=52.103.13.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EPMRyAjN+W8qFnLxjJMIIPIfpsC2gRNU004SPlW6OQwTneYFfTeI+3qE71Og0ZRFyIPx+b5XIUXeDEaRyYtgSuIhEkjstSaZmjEyUlrbulYelctwnDfnC8SnN7zeJOnSh0ef38pLWLshJeURPlYpr3lCl/ptCV3KFc6iz1mVBMp51RjFFPmp6KEjA3dKQkWv2i+4nviUp7/zzShPB4pAllHfYs6fvaNZWsTja6I9n4OKLy/VI+aFY06fjnlXq91nITTZ1KS/TIIX3r4AbtscXp1nU8CLoayi/EufvFq1JcAzgzYed4DRto8C9IpApZqsaSRAddNMeK//V8yJ5zHTWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZHm05Q34DhxEHNbbuGXfaw7J/tQ6yPdt35vO0/AiPo=;
 b=JaBX/RGku3/P17vmyi3tDu/GAz2cfbP1xfG07yRNT8fIUzKg+ZqqdbsPQNKz4ZOq925VDgujYIbQRxlJY7YAeFNATqjdrXCwYzG+zsY9X+DRriakroGR7dNocNp0/oBAep2UHc4rcrSofBMtxeDEhk9HSvX/h3lAO/xeKHq3vGtSSCNfPHOgbn8C3RBbWu2KKUW1L5pszBH5WLcfsxMJ3/av+wlEJrzqNfD4wv7WW4GONAencAedHMjPKmnQ608GPtTe4m/t2v9+YgEANUIZPBngeQk2cnlkAU1euOT05pmdr5rQISKrZihW+Mbyy1jmQX1EHNmrZuGiFLuzTqWstA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZHm05Q34DhxEHNbbuGXfaw7J/tQ6yPdt35vO0/AiPo=;
 b=QwTeXWUXQPpEwmUnGQUqHlk7zIQggitcPxYiM2kSPpmzc/qrPoJsUEf0PBsww2Ha0J7oN4qkr0RwrDwPfoeCKNwvpjXIu+/Z3uNbffYyF0ZE1oG+/8xkuMuQrweKwETYRZoJchRraMZOqmjkC+oYwpXxZkFBIdK+b0YkkynZ1XRjgL9tn4zm+uJCsdxDqQEoTZca42F4Q7qLdGyPff5oWUShovVDteW3dXnHXZ30FlwQ5msfRUOjCixyJR6epGREsaGAAk4po8FBDmWID1/KDEzPOezq9GDdPBeW35Ia2ectQ/2WUK8xFb2dCBCI1U1/G3g0FYwXy/Dt4v60mD4Vug==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH0PR02MB7397.namprd02.prod.outlook.com (2603:10b6:510:1d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Wed, 5 Nov
 2025 15:22:58 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 15:22:58 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Miroslav
 Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Song Liu
	<song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin
	<chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch
	<dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Thread-Topic: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Thread-Index: AQHcJ+6qpEmfJskj+02bf6oIo51EqLTUFK6ggAK7zwCAAjZrQA==
Date: Wed, 5 Nov 2025 15:22:58 +0000
Message-ID:
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
In-Reply-To: <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH0PR02MB7397:EE_
x-ms-office365-filtering-correlation-id: 6af2aea8-cd43-4cc3-7c87-08de1c7f33b9
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|13091999003|15080799012|8062599012|31061999003|19110799012|8060799015|41001999006|10092599007|12121999013|3412199025|440099028|39105399003|41105399003|102099032|40105399003|56899033;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hu7O4IxBza4Pg4DBMBFcjeT7gbw4m9GooVc1rO4/bO4Omqlv/x+n8d1p6lKz?=
 =?us-ascii?Q?6bXgv2EMWnkSzlU5IL5PMSZjSnCXApbb1qyUEl0wjrxztosSbrMc0vyrYy3G?=
 =?us-ascii?Q?LE9ptfu8yqEu1k1wXDTz9lGB5m3J/OTlh0c5UnpnVDI0f+4lbCh6dyn2g83/?=
 =?us-ascii?Q?uOhauJlWZa0TcSFnPqoq7IfyEUQqgzacj4TT9LpNERuY/6ndLDI3tuQj9puq?=
 =?us-ascii?Q?vRr2in7uKZ5o3LuygX7QSwe/4BiWiYmPU8GUu1enr74QoElPFmY7BNcNhwfE?=
 =?us-ascii?Q?RxF7sfY9AxOSvBoYR0vEhgsuczIT0soC8wljHpaZ7izcTZeYXOrl92XvITwB?=
 =?us-ascii?Q?0s6yy1G1STIumdJ8oa4ex+LiBI7DtLgojNWY0ERAFG8C9h/pI2aS7Rj1L8FH?=
 =?us-ascii?Q?DIQOUlrM/0g1Pzscuq+zxwTb2g/CKyQOgqoK/O0hkRCOOLhvXz9E4WcAXJ9M?=
 =?us-ascii?Q?6pcw0eFzbLDoYTU35X+dj8+QNWurIP9fvAGC5Av+95B3znxYevTajvGWxr4n?=
 =?us-ascii?Q?3cDXDLfXAVos70LjXFn4CvjWMldyropshuklfJnXenrGoAGCaIPJqOFdwJpN?=
 =?us-ascii?Q?rZKYn7aE5caFQatVrPACZA0P3na6ZxO539gILVYAlD/PP3RBTkjVUS367tuj?=
 =?us-ascii?Q?ScgUuVFlKXJ5qY+Jk6eUTGHaGSFK0vqKSvWBxVWLJF3YFqRh9mg7l6YZvnFe?=
 =?us-ascii?Q?pnq2Rrd0xtAE8gyxWgDVOYFAwK8dKAEf0qY+S+EPkHxh6j02Kc7zM685FRp6?=
 =?us-ascii?Q?rXhg9FAXn4PV8JDlgE2WRSh5BeJApRHfl3cDgTj1+wvDct4t6ANJTsWVUdPy?=
 =?us-ascii?Q?LxV1874mt6zlKh5WgNUkGWSOCAUCSoecp1gY19CEooYKgnRVwSPgk59udKuY?=
 =?us-ascii?Q?mtg8SeK09cMOhrDWhKVo+9+vRmzBoi1fhqDEypqH6+T7DBKsI+22ssx6MPS5?=
 =?us-ascii?Q?ojz76Q3tGOSidil5t9jZKZE56x1SfXfYL6E8C/t1mhe109IyOVwqK5xNVxsS?=
 =?us-ascii?Q?aKl2jZid6U+Wa63ONHbXFQfnYSEStNJLsak6AirHc3UfOJ2pDaMB9TomDTdq?=
 =?us-ascii?Q?RCMG5nV8fjBZdJGIJMo+dj4JP1LYSwo+UFED/os9wWKndE5JC6nNWeC6b2fB?=
 =?us-ascii?Q?uvcJliTOZ96q8UM1bqSMeZbSR9EcFDR3pFFp4n8/gaY7mUWk/3+sEGIP7p4T?=
 =?us-ascii?Q?3sq7+DWT7ADqkfhIO1E3UjCntyECoOrufZ+0EzsAMdJX3hNKVCY9hkGcmXks?=
 =?us-ascii?Q?pDdkJcy7KYGcXjomO6gVM0Q9gG25gOfoMsCMOdWXbI2JQnMRENO3gUV88ibx?=
 =?us-ascii?Q?SXgWPXZcBCTlIuhaGDQMbU0PC715GnK+Jo2AgMLvqKifXQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xoa63Z8WfRSYwH8QuvETMZv3nPOju3Tezr/fZfPld5z5IvX+cokkl+sPhFEH?=
 =?us-ascii?Q?ABtQtSPmoLp1VN/02zeS21y0vy36JNAR/xD4/zCy4gLJxWJoGxwswmJbMeWo?=
 =?us-ascii?Q?l17Dl4FRufuNXYHE4H4m75gQuWjt05NkwHQ5rx4hBO7iIhm1C4GJ+tvIbJPE?=
 =?us-ascii?Q?Y3d0sYF1f7nRYQXJFWQHGJanq8oJGPpLfgB/TVW8hXC8iMWDtlyuZJZXwjun?=
 =?us-ascii?Q?FS0oQwj0S7PvhJTYJQp9KiKxMDH2i/ZTiA80/p/und67AnoR3o/Ew/ly4SBG?=
 =?us-ascii?Q?mSf3YFqMq3gnBOHOgQ4jUdXZFiQxj/FrepO7XBjVp3NmBtANbiigyiskTApr?=
 =?us-ascii?Q?Tp3zJWZh2NPYU+w0rFXzDMpnfJXP5UxHkhE89NCDTwHqQSMbxRa0491u3/Vl?=
 =?us-ascii?Q?9DTkmDbrfHUXhzGi9dCyQ/oc3dPbxrZr6gSvd0csudl0LlyJ5fl0Szi+w8lx?=
 =?us-ascii?Q?FTksHUiWxXc8s3bHFGTRVXUxVwb8peCmDeGrQYWeiWfX9khN1X65tHngirYG?=
 =?us-ascii?Q?amXnhtkVWi8hbW5WGYdnvUnrBf4gnI/QTewpWUck1xCcugpztfCsprEADL4O?=
 =?us-ascii?Q?ZH8wqDs0H4c49eZRwTqwN72P4z3wysTELwH24KAr2vWJiSGCAwfOMS38FCPY?=
 =?us-ascii?Q?c5BgxbTn6StwX+W0MfCPFsR7qYsifvToKp+7Y5Lf0g0tHJikKQIdPDy1QpnG?=
 =?us-ascii?Q?0zZRR0UieziBrsXrPDTZhkErGzYstMsutkn2JCKM+NuXmt4hY2ucftUQRTkI?=
 =?us-ascii?Q?JGFxqXu1O2v4kVvERlKbuPtOmdg6bytbKfc25NoKP/XThffkMXQ5RYvWGVAS?=
 =?us-ascii?Q?yv3zg6PqHSfCnozmCo3pxoB7kYDfvZYgoycT2PBaCjt5svq/2Ml7XTEG8Hod?=
 =?us-ascii?Q?W+Qw0+w244/tyh9KnIaMAlbMWiWFspyNmS+fWg4slef/ZdZQVqkzHPRofVk5?=
 =?us-ascii?Q?LnhOne0YpV1GBnCApk3CUfe2fKoADNuMrRSYOGn02PKiWgMwU3pL6gtayECf?=
 =?us-ascii?Q?bsZ9o5s8QHJ4fMlzGRojHXyiqVU+wTtVh6m4KDDezqrS++jk+kKr51YK1vOI?=
 =?us-ascii?Q?kPc4djycE1RrlvMg/YrcVB2Hs09nhHlul8v78jogB1Ez1lisVj6n4rlKQY8t?=
 =?us-ascii?Q?cwlMYfNHNdhAXHlFo52rEnjKK8kVhnBalBflizb7TDUUNRQApv4X2iykb/Cv?=
 =?us-ascii?Q?gYqbcpFJfWc8OgUZES1cP6ab21kND6ruXrAPYZMvOIYLBmVuow0ShwROEJc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af2aea8-cd43-4cc3-7c87-08de1c7f33b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 15:22:58.6795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7397

From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Monday, October 27, 2025 3=
:22 PM
>=20

Sorry for the delay in my follow-up.  I've been travelling the past 10 days=
.

> On Mon, Oct 27, 2025 at 01:19:10AM +0000, Michael Kelley wrote:
> > It turns out that Ubuntu 20.04 installed the 0.7.3-1 version of libxxha=
sh. But from a
> > quick look at the README on the xxhash github site, XXH3 is first suppo=
rted by the
> > 0.8.0 version, so the compile error probably makes sense. I found a PPA=
 that offers
> > the 0.8.3 version of xxhash for Ubuntu 20.04, and that solved the probl=
em.
> >
> > So the Makefile steps above that figure out if xxhash is present probab=
ly aren't
> > sufficient, as the version of xxhash matters. And the "--checksum not s=
upported"
> > error message should be more specific about the required version.
> >
> > I reproduced the behavior on two different Ubuntu 20.04 systems, but
> > someone who knows this xxhash stuff better than I do should confirm
> > my conclusions. Maybe the way to fix the check for the presence of xxha=
sh is
> > to augment the inline test program to include a reference to XXH3_state=
, but
> > I haven't tried to put together a patch to do that, pending any further=
 discussion
> > or ideas.
>=20
> Thanks for reporting that.  I suppose something like the below would work=
?
>=20
> Though, maybe the missing xxhash shouldn't fail the build at all.  It's
> really only needed for people who are actually trying to run klp-build.
> I may look at improving that.

Yes, that would probably be better.

>=20
> diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> index 48928c9bebef1..8b95166b31602 100644
> --- a/tools/objtool/Makefile
> +++ b/tools/objtool/Makefile
> @@ -12,7 +12,7 @@ ifeq ($(SRCARCH),loongarch)
>  endif
>=20
>  ifeq ($(ARCH_HAS_KLP),y)
> -	HAVE_XXHASH =3D $(shell echo "int main() {}" | \
> +	HAVE_XXHASH =3D $(shell echo -e "#include <xxhash.h>\nXXH3_state_t *sta=
te;int main() {}" | \
>  		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || =
echo n)
>  	ifeq ($(HAVE_XXHASH),y)
>  		BUILD_KLP	 :=3D y

Indeed this is what I had in mind for the enhanced check. But the above
gets a syntax error:

Makefile:15: *** unterminated call to function 'shell': missing ')'.  Stop.
make[4]: *** [Makefile:73: objtool] Error 2

As a debugging experiment, adding only the -e option to the existing code
like this shouldn't affect anything,=20

	HAVE_XXHASH =3D $(shell echo -e "int main() {}" | \

but it causes HAVE_XXHASH to always be 'n' even if the xxhash library
is present. So the -e option is somehow fouling things up.

Running the equivalent interactively at a 'bash' prompt works as expected.
And your proposed patch works correctly in an interactive bash. So
something weird is happening in the context of make's shell function,
and I haven't been able to figure out what it is.

Do you get the same failures? Or is this some kind of problem with
my environment?  I've got GNU make version 4.2.1.

Michael

> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.=
c
> index 1e1ea8396eb3a..aab7fa9c7e00a 100644
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

