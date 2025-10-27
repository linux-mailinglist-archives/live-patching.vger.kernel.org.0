Return-Path: <live-patching+bounces-1817-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA1EC0B968
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 02:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BC113B7291
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 01:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE1D23D2B4;
	Mon, 27 Oct 2025 01:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="MB82AIGL"
X-Original-To: live-patching@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010000.outbound.protection.outlook.com [52.103.12.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC231A9FB8;
	Mon, 27 Oct 2025 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.12.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761527958; cv=fail; b=XPYDEQVLV7Pz5BIy6/ChufpuPO7nDhdfptwJxBVDh2AQ3DQv+ZgrwVWjOmos75O6vP6lDu/8cLw1jounNeF/Y8xM2r9bykD3cI581PXzN6EwtvEJq0VjAlAvVm1ZdRN5MW7NKhGMbDmbVKJaYJqnrzvS7+drO0a0z639frNQlCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761527958; c=relaxed/simple;
	bh=ycAKZKMpbGdwHFkkU9jmDyPcuBTLBiEA1P9sFXF4JRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ge76QnMO5qai/QVc4Vfqey62VsUermwlWbRfchU4fpn5zhytH2JfKQ+Fpu5t0zctvIPe34MpK/IbkNMm5Le9RI1a46oNnldUTe6F8vtVy4vBBl7/wp/Ht60X4xUYbpqErzPHRuZG+yl5aNmHbYC9Z0kY1yEMOXZE0YGGPWxCr9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=MB82AIGL; arc=fail smtp.client-ip=52.103.12.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CCCoFeeXUh7PMPnG/W45JmG8yMLii/lqKaUBhE2DhS0RT9cWrH+Xgajg7ZptQb+A+wlEdeI1OG5o5kHXxE1Y3tWwC34c1ZL+zl+h2TUWd34CBAPZOghrI+fMo/Ce6Ze7DytT3KJEu/yMedcc7eHKhimhiFDUdNhCV34Y7Xaz9uYklAJcgisjCXz+Jz1HqOMG0m78qbIedahjqX7+DjKs4pedFEmzn2nL+TZcYHGb2oRIaXlby/Z52VJkkT+o9DkL9+PZ8Z3x5qgGa0qI7S7JULNuYHHFSWkQhRwgkLah1X7qiKgfeXKIkU3iQthud7SbIRx2s6/eIMpEH3Ov4qWZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiBUQXwL4sRdARc2iHopcFZeavYNRAx3/QgebwxlUcI=;
 b=GiXPGqCcfbq0hxFMAgBOxpgdOONG1GDDZPIVAJH/KTFu/Ss8dbYA0kTAGHeSnCK3rtwUo8jQ2fMC5Z1UxgLb01a+63hLPGJrIwQD58mPyEAdfWjnfMSUiW12nAfh32eL/qyF/y0gBMgK2M0JO3IihEVJOhWG8rY5CQFWaDGwIL5o0E7Z9Xigogdfbxmrt96xoeSSe8rTfs7d6TLoVYF43e59MLV4oVROYouyY73SwGA1UOMtublypE5GDYdokxdiksZLAEiRS0hlzHIvvbP+Nyzaejh7j/Z6GHFYIwqS/DM6wvWdEdaEyCRhMaEA2zK0UfpAafTMNRe21Fvy1mM0fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiBUQXwL4sRdARc2iHopcFZeavYNRAx3/QgebwxlUcI=;
 b=MB82AIGLVORch3WwPkZVRSnQViP3KzexgoyxZHqXr357xQTlEYa4W/5lXM/sh6N/69WBfOE9mjZL786AcPCJnkXfkkgKXTxtOAcHItXFh8bBoveGVY/oqcBj1Hwc3Y076ZxxJq2DCSUJr11czeC3/XopLExsb9opStMW1+l8RRNIKXJmsD8FM0uQ4t7jJdDCH9jZyFP6idBghF1vlnjAI9BxFv9xd4tXF/eWE1q6h/KPbR9NnWkdisUo1kqVBw0rl1K4IMinesrBoJ3KQdmtAmqfPr9eWbIIsaL92BT0qN51zaR7FM8jEwyEY819wR4xh+bdnv1k0XPOaxLmV6T6rg==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by SA0PR02MB7484.namprd02.prod.outlook.com (2603:10b6:806:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Mon, 27 Oct
 2025 01:19:12 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9253.011; Mon, 27 Oct 2025
 01:19:11 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Mladek
	<pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Joe Lawrence
	<joe.lawrence@redhat.com>, "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>, Song Liu <song@kernel.org>, laokz
	<laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza
	<mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, Fazla Mehrab
	<a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay
 Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, Peter
 Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Thread-Topic: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Thread-Index: AQHcJ+6qpEmfJskj+02bf6oIo51EqLTUFK6g
Date: Mon, 27 Oct 2025 01:19:10 +0000
Message-ID:
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
In-Reply-To:
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|SA0PR02MB7484:EE_
x-ms-office365-filtering-correlation-id: 812b5c2f-a4e4-46f4-2332-08de14f6d52c
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|461199028|12121999013|8060799015|8062599012|10092599007|41001999006|15080799012|13091999003|17081999003|31061999003|56899033|39105399003|40105399003|41105399003|3412199025|440099028|102099032|12091999003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?g49bxohGuMjAw+sdM/UWcOXwJFT6NK3xxW8YFPzW41wKhamoIYFIjSo/fpv/?=
 =?us-ascii?Q?JGsiUPyHwcHQB2892/mH0C+A02Dbjl78Ev+JNUErOZGHV+sczXktJGm2H1Do?=
 =?us-ascii?Q?BXDQTs0tD+3kYqwL1J7PZh/znkFcGyCJ921qsEFsV+1pGBYmx6x02nxuUASP?=
 =?us-ascii?Q?hY2R6Zjyg1dxyoHwB9ea3teQio/t8SWwxRlS33x8smaDl75M7Ynmcf4tpYUj?=
 =?us-ascii?Q?XWXboeqM9j/52Zsl2ihekca+jjmdz9+he6/O+zbuhjpcSAQNhjSNOFdpAcI3?=
 =?us-ascii?Q?Z2dx0ocahDSHLohd4TauPqtBFQLHZPOFInL794vEMBFck+G2LxyPxyTbldVW?=
 =?us-ascii?Q?kKdVO7rRqSYDxc/VGqY91HoMw83pNtorHSbhJksYEQvFVTkcbnMjNCHAV7wW?=
 =?us-ascii?Q?wrvfZXwOln3Ugg/brMuBS6rVKLuCX6iOyh5vjAcBhiIJ1D7rgJ7TwicMvWPp?=
 =?us-ascii?Q?FQG6XEhHb82ok4NKRlsE+0W2k5003YucNNF6C3e/xToK4SFf03k+BdQWrTCx?=
 =?us-ascii?Q?X0aoEYpObti+dHg7gSLcb2RIuBe0Sa3yraSsIFNIDkhH5to6MMf6iP6r048E?=
 =?us-ascii?Q?ShCFU2Ad57UBqSPjY1d7MeyBFFZwsScYpWDqWiEV4ji3QoUyS0/8KvJf7I0x?=
 =?us-ascii?Q?r48pC12CXMEZSWOhI6eNEyZMySlcEw4YAyXcayiww9TxCGnbdyPFPlt2pNKS?=
 =?us-ascii?Q?zbkiPMg0bZtSqUHkB1340qAShD4W7yXH9HB2+FeFJAZ/2r0dDCwg/fsGrP8e?=
 =?us-ascii?Q?OCIjvhNAV9gKsTvr+kLgZWJeWjF7mt6vowzbElr4dYvLPNv1ucgobhwIQ65Y?=
 =?us-ascii?Q?+lEuTEV/jCWYel5L4NpKLH/A2SAbaJCDyuRdkAz5Dom1/TuC0cTvzxF6pK88?=
 =?us-ascii?Q?T+8vyMmF0OAHXFVmm2bjAgRJ4W3FwN8CS2YyHJz3tPSnJlzI1NG4drdGZjvB?=
 =?us-ascii?Q?B7i9liF4skg524URztBpoYOYOR4g+uEqqjWsb+LNg+242toDANXCaHeB2AfL?=
 =?us-ascii?Q?mZqi9YF+YSQewU2X/uvf+nB3y75g+LKXVUiiDSpjeVwy1p6q2g6E77UJS+/w?=
 =?us-ascii?Q?p2JLXe3k+34DMXO0YkWNDOKyo+GHDUTDR7bn+4lZs3J5f2EQpX8NS79sq0X+?=
 =?us-ascii?Q?JMYRdjboV2jHfLLgKCZAeaj4fZAX+LDkPvMtFZIa/nuhcb03Gzr/s8b71+XN?=
 =?us-ascii?Q?AmUhW03myVB2icDlFvEqjJfCNPJKxTS/HEEV2oqoPoB9RiUF/b0U7BWq2D+6?=
 =?us-ascii?Q?JxPMUdG3R2i3siw+M0PnUgKpJnhKOn9nzqkWXwm1yxYukR/udHNIjsyjFQyX?=
 =?us-ascii?Q?dw5w6226XM92K8s+NyvBes7EORiqtv0WFsIa3gtccC7zD4xvIPttVDV5SorO?=
 =?us-ascii?Q?0YH9XlFueeuMqkbBXhlMzKimRiY4gha7ypFeXD5zS622KeJflw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vjQQM+AWpMlJ/cUhuA0mE4qPAoat4s55NnxqWGKyGdq4a9+QxOme2E1YtUAi?=
 =?us-ascii?Q?IHhFzd/OicJGmSm1qKIDxsC/+cbK6kLaBLuB387FMsBgb8R+ZPBWiVgwsTzB?=
 =?us-ascii?Q?XFB77QcfRj1B/h9djozX1c9y/FcH36UVtJ1gbV/Y4QAeoYMoTQqOZEkLgIGC?=
 =?us-ascii?Q?5h3Yl7pho0S0HeDS1r52Hk45u+1uB5FdmO2tncFlTUd9xSJ9Goh4X9xjMF2O?=
 =?us-ascii?Q?d5q70FPnOiGB8r18fT5cKHc5PMkP0iSzv5vU8OEzG+HuNg9CC3Y4FbidmHgQ?=
 =?us-ascii?Q?jIzIaczA2ENmBmakgomqqKp+7Y1v2NWlF+Qa/aGKq4NJnSu5jvtwUoWknU8H?=
 =?us-ascii?Q?8styodPod9lTRNJvwR08zeRcPc+ZcOCLsp7jxcV7yKDzf5NbcC3CWaZtJ+tf?=
 =?us-ascii?Q?iUIrsCGVLwogU4w8X6H0ql7K4FcjHHW4uDJBs+8BlF5ltaCJHcpelz4ULFYV?=
 =?us-ascii?Q?Qgys9fLZGAKymwOLOwWl0WbzHwJwSCmfRll1s7YzMO4zD0KPhb9u4ypD3j1d?=
 =?us-ascii?Q?HL7GuNnPu6sD8X74RUtBB4tukeZ8N8WMKL0xV7KF3hL1NNzpnWcngUkU/JoI?=
 =?us-ascii?Q?5vn4Gc9H0FQhkaw0M9vGh8XIymRlcfbnah/zKfm5iMxOJyI5v5BdUDuWb6gz?=
 =?us-ascii?Q?Uldj+UaEgZZigPlSO6XRTF8E7s2eBc8Cs7PIMXHy+yRwV48UPToeHIxkF3aL?=
 =?us-ascii?Q?a7Lcz8zXIDst1e9BdISpdI4OYkfmd51STZoE5vYT01kipjk5BtxaVphWnN97?=
 =?us-ascii?Q?wb1pDR1fecFrsd9vSRkMFGfYAXi/aFr/bkAlKlQ/chI0pQfWoQSHr0NgiNq2?=
 =?us-ascii?Q?K7Bd8AMxghEWmwC+OSCOwhccfWFnDHjrv0p7IBydS13+msTsFFRJlFCfvJXI?=
 =?us-ascii?Q?gqRDx25nYHm9sqRdBGExynK54aboOwOo1/IjTfLUZAOEZlEdbsR1PbkhRMM7?=
 =?us-ascii?Q?o65s9Ln/fH4FV3hScfYf1Pki/mxQI/g4BB3mYGpNveFT4LSIRo9la21jmTmv?=
 =?us-ascii?Q?AA8Nn4DqUIhlMSVqT/Q3iV7JcjDNRKkKACQ26V8uiFivd4H5pZunfg6efXpO?=
 =?us-ascii?Q?+caPgsewXQJavDGxSOcmdTFW7UY2+mY8HgmqJEuarbekEPpqYR7W10vjb2Dr?=
 =?us-ascii?Q?ijp5a6iSlaSrzw8YhUxrvt1ORYI9N7I4wblxc6rjHBsNMFtHUdTPG9FxEAFX?=
 =?us-ascii?Q?KRRZCIbi7rOtWkgxNYvqUFJtHBvODiI6qHCUdQ6khElholrTtkw/E4ba8yQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 812b5c2f-a4e4-46f4-2332-08de14f6d52c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 01:19:10.3513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7484

From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Wednesday, September 17, 2=
025 9:04 AM
>=20
> In preparation for the objtool klp diff subcommand, add a command-line
> option to generate a unique checksum for each function.  This will
> enable detection of functions which have changed between two versions of
> an object file.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/Makefile                        |  38 +++--
>  tools/objtool/builtin-check.c                 |  11 +-
>  tools/objtool/check.c                         | 140 +++++++++++++++++-
>  tools/objtool/elf.c                           |  46 +++++-
>  tools/objtool/include/objtool/builtin.h       |   5 +-
>  tools/objtool/include/objtool/check.h         |   5 +-
>  tools/objtool/include/objtool/checksum.h      |  42 ++++++
>  .../objtool/include/objtool/checksum_types.h  |  25 ++++
>  tools/objtool/include/objtool/elf.h           |   4 +-
>  9 files changed, 289 insertions(+), 27 deletions(-)
>  create mode 100644 tools/objtool/include/objtool/checksum.h
>  create mode 100644 tools/objtool/include/objtool/checksum_types.h
>=20
> diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> index fc82d47f2b9a7..958761c05b7c3 100644
> --- a/tools/objtool/Makefile
> +++ b/tools/objtool/Makefile
> @@ -2,6 +2,27 @@
>  include ../scripts/Makefile.include
>  include ../scripts/Makefile.arch
>=20
> +ifeq ($(SRCARCH),x86)
> +	BUILD_ORC    :=3D y
> +	ARCH_HAS_KLP :=3D y
> +endif
> +
> +ifeq ($(SRCARCH),loongarch)
> +	BUILD_ORC	   :=3D y
> +endif
> +
> +ifeq ($(ARCH_HAS_KLP),y)
> +	HAVE_XXHASH =3D $(shell echo "int main() {}" | \
> +		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || =
echo n)
> +	ifeq ($(HAVE_XXHASH),y)
> +		LIBXXHASH_CFLAGS :=3D $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/=
dev/null) \
> +				    -DBUILD_KLP
> +		LIBXXHASH_LIBS   :=3D $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/de=
v/null || echo -lxxhash)
> +	endif
> +endif

I ran into an interesting issue with xxhash when building the linux-next202=
51024
kernel on Ubuntu 20.04 for x86/x64. My first result was the new error that =
this
patch adds (as modified by Boris Petkov's follow-up patch):

error: objtool: --checksum not supported; install xxhash-devel/libxxhash-de=
v and recompile

OK, not a big deal. I installed libxxhash-dev using:

# apt install libxxhash-dev

Then objtool got a compile error when building:

  CC      /data/linux-next20251024/tools/objtool/libsubcmd/exec-cmd.o
  CC      /data/linux-next20251024/tools/objtool/libsubcmd/help.o
  CC      /data/linux-next20251024/tools/objtool/libsubcmd/pager.o
  CC      /data/linux-next20251024/tools/objtool/libsubcmd/parse-options.o
  CC      /data/linux-next20251024/tools/objtool/libsubcmd/run-command.o
  CC      /data/linux-next20251024/tools/objtool/libsubcmd/sigchain.o
  CC      /data/linux-next20251024/tools/objtool/libsubcmd/subcmd-config.o
  LD      /data/linux-next20251024/tools/objtool/libsubcmd/libsubcmd-in.o
  AR      /data/linux-next20251024/tools/objtool/libsubcmd/libsubcmd.a
  INSTALL libsubcmd_headers
  CC      /data/linux-next20251024/tools/objtool/arch/x86/special.o
In file included from /data/linux-next20251024/tools/objtool/include/objtoo=
l/elf.h:18,
                 from /data/linux-next20251024/tools/objtool/include/objtoo=
l/objtool.h:13,
                 from /data/linux-next20251024/tools/objtool/include/objtoo=
l/arch.h:11,
                 from /data/linux-next20251024/tools/objtool/include/objtoo=
l/check.h:11,
                 from /data/linux-next20251024/tools/objtool/include/objtoo=
l/special.h:10,
                 from arch/x86/special.c:4:
/data/linux-next20251024/tools/objtool/include/objtool/checksum_types.h:15:=
9: error: unknown type name 'XXH3_state_t'
   15 |         XXH3_state_t *state;
      |         ^~~~~~~~~~~~

It turns out that Ubuntu 20.04 installed the 0.7.3-1 version of libxxhash. =
But from a
quick look at the README on the xxhash github site, XXH3 is first supported=
 by the
0.8.0 version, so the compile error probably makes sense. I found a PPA tha=
t offers
the 0.8.3 version of xxhash for Ubuntu 20.04, and that solved the problem.

So the Makefile steps above that figure out if xxhash is present probably a=
ren't
sufficient, as the version of xxhash matters. And the "--checksum not suppo=
rted"
error message should be more specific about the required version.

I reproduced the behavior on two different Ubuntu 20.04 systems, but
someone who knows this xxhash stuff better than I do should confirm
my conclusions. Maybe the way to fix the check for the presence of xxhash i=
s
to augment the inline test program to include a reference to XXH3_state, bu=
t
I haven't tried to put together a patch to do that, pending any further dis=
cussion
or ideas.

Michael

> +
> +export BUILD_ORC
> +
>  ifeq ($(srctree),)
>  srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
>  srctree :=3D $(patsubst %/,%,$(dir $(srctree)))
> @@ -36,10 +57,10 @@ INCLUDES :=3D -I$(srctree)/tools/include \
>  	    -I$(srctree)/tools/objtool/arch/$(SRCARCH)/include \
>  	    -I$(LIBSUBCMD_OUTPUT)/include
>=20
> -OBJTOOL_CFLAGS  :=3D -std=3Dgnu11 -fomit-frame-pointer -O2 -g \
> -		   $(WARNINGS) $(INCLUDES) $(LIBELF_FLAGS) $(HOSTCFLAGS)
> +OBJTOOL_CFLAGS  :=3D -std=3Dgnu11 -fomit-frame-pointer -O2 -g $(WARNINGS=
)	\
> +		   $(INCLUDES) $(LIBELF_FLAGS) $(LIBXXHASH_CFLAGS)
> $(HOSTCFLAGS)
>=20
> -OBJTOOL_LDFLAGS :=3D $(LIBSUBCMD) $(LIBELF_LIBS) $(HOSTLDFLAGS)
> +OBJTOOL_LDFLAGS :=3D $(LIBSUBCMD) $(LIBELF_LIBS) $(LIBXXHASH_LIBS)
> $(HOSTLDFLAGS)
>=20
>  # Allow old libelf to be used:
>  elfshdr :=3D $(shell echo '$(pound)include <libelf.h>' | $(HOSTCC) $(OBJ=
TOOL_CFLAGS) -x
> c -E - 2>/dev/null | grep elf_getshdr)
> @@ -51,17 +72,6 @@ HOST_OVERRIDES :=3D CC=3D"$(HOSTCC)" LD=3D"$(HOSTLD)"
> AR=3D"$(HOSTAR)"
>  AWK =3D awk
>  MKDIR =3D mkdir
>=20
> -BUILD_ORC :=3D n
> -
> -ifeq ($(SRCARCH),x86)
> -	BUILD_ORC :=3D y
> -endif
> -
> -ifeq ($(SRCARCH),loongarch)
> -	BUILD_ORC :=3D y
> -endif
> -
> -export BUILD_ORC
>  export srctree OUTPUT CFLAGS SRCARCH AWK
>  include $(srctree)/tools/build/Makefile.include
>=20
> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.=
c
> index 07983cdeded0f..101f05606a990 100644
> --- a/tools/objtool/builtin-check.c
> +++ b/tools/objtool/builtin-check.c
> @@ -73,6 +73,7 @@ static int parse_hacks(const struct option *opt, const =
char *str, int unset)
>=20
>  static const struct option check_options[] =3D {
>  	OPT_GROUP("Actions:"),
> +	OPT_BOOLEAN(0,		 "checksum", &opts.checksum, "generate per-function che=
cksums"),
>  	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integr=
ity (kCFI) function preambles"),
>  	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skyla=
ke", "patch toolchain bugs/limitations", parse_hacks),
>  	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
> @@ -160,7 +161,15 @@ static bool opts_valid(void)
>  		return false;
>  	}
>=20
> -	if (opts.hack_jump_label	||
> +#ifndef BUILD_KLP
> +	if (opts.checksum) {
> +		ERROR("--checksum not supported; install xxhash-devel and recompile");
> +		return false;
> +	}
> +#endif
> +
> +	if (opts.checksum		||
> +	    opts.hack_jump_label	||
>  	    opts.hack_noinstr		||
>  	    opts.ibt			||
>  	    opts.mcount			||
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 969a61766f4a6..fec53407428e2 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -14,6 +14,7 @@
>  #include <objtool/check.h>
>  #include <objtool/special.h>
>  #include <objtool/warn.h>
> +#include <objtool/checksum.h>
>=20
>  #include <linux/objtool_types.h>
>  #include <linux/hashtable.h>
> @@ -971,6 +972,59 @@ static int create_direct_call_sections(struct objtoo=
l_file *file)
>  	return 0;
>  }
>=20
> +#ifdef BUILD_KLP
> +static int create_sym_checksum_section(struct objtool_file *file)
> +{
> +	struct section *sec;
> +	struct symbol *sym;
> +	unsigned int idx =3D 0;
> +	struct sym_checksum *checksum;
> +	size_t entsize =3D sizeof(struct sym_checksum);
> +
> +	sec =3D find_section_by_name(file->elf, ".discard.sym_checksum");
> +	if (sec) {
> +		if (!opts.dryrun)
> +			WARN("file already has .discard.sym_checksum section,
> skipping");
> +
> +		return 0;
> +	}
> +
> +	for_each_sym(file->elf, sym)
> +		if (sym->csum.checksum)
> +			idx++;
> +
> +	if (!idx)
> +		return 0;
> +
> +	sec =3D elf_create_section_pair(file->elf, ".discard.sym_checksum", ent=
size,
> +				      idx, idx);
> +	if (!sec)
> +		return -1;
> +
> +	idx =3D 0;
> +	for_each_sym(file->elf, sym) {
> +		if (!sym->csum.checksum)
> +			continue;
> +
> +		if (!elf_init_reloc(file->elf, sec->rsec, idx, idx * entsize,
> +				    sym, 0, R_TEXT64))
> +			return -1;
> +
> +		checksum =3D (struct sym_checksum *)sec->data->d_buf + idx;
> +		checksum->addr =3D 0; /* reloc */
> +		checksum->checksum =3D sym->csum.checksum;
> +
> +		mark_sec_changed(file->elf, sec, true);
> +
> +		idx++;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int create_sym_checksum_section(struct objtool_file *file) { retu=
rn -EINVAL; }
> +#endif
> +
>  /*
>   * Warnings shouldn't be reported for ignored functions.
>   */
> @@ -1748,6 +1802,7 @@ static int handle_group_alt(struct objtool_file *fi=
le,
>  		nop->type =3D INSN_NOP;
>  		nop->sym =3D orig_insn->sym;
>  		nop->alt_group =3D new_alt_group;
> +		nop->fake =3D 1;
>  	}
>=20
>  	if (!special_alt->new_len) {
> @@ -2527,6 +2582,14 @@ static void mark_holes(struct objtool_file *file)
>  	}
>  }
>=20
> +static bool validate_branch_enabled(void)
> +{
> +	return opts.stackval ||
> +	       opts.orc ||
> +	       opts.uaccess ||
> +	       opts.checksum;
> +}
> +
>  static int decode_sections(struct objtool_file *file)
>  {
>  	mark_rodata(file);
> @@ -2555,7 +2618,7 @@ static int decode_sections(struct objtool_file *fil=
e)
>  	 * Must be before add_jump_destinations(), which depends on 'func'
>  	 * being set for alternatives, to enable proper sibling call detection.
>  	 */
> -	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
> +	if (validate_branch_enabled() || opts.noinstr) {
>  		if (add_special_section_alts(file))
>  			return -1;
>  	}
> @@ -3527,6 +3590,50 @@ static bool skip_alt_group(struct instruction *ins=
n)
>  	return alt_insn->type =3D=3D INSN_CLAC || alt_insn->type =3D=3D INSN_ST=
AC;
>  }
>=20
> +static void checksum_update_insn(struct objtool_file *file, struct symbo=
l *func,
> +				 struct instruction *insn)
> +{
> +	struct reloc *reloc =3D insn_reloc(file, insn);
> +	unsigned long offset;
> +	struct symbol *sym;
> +
> +	if (insn->fake)
> +		return;
> +
> +	checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn=
-
> >len);
> +
> +	if (!reloc) {
> +		struct symbol *call_dest =3D insn_call_dest(insn);
> +
> +		if (call_dest)
> +			checksum_update(func, insn, call_dest->demangled_name,
> +					strlen(call_dest->demangled_name));
> +		return;
> +	}
> +
> +	sym =3D reloc->sym;
> +	offset =3D arch_insn_adjusted_addend(insn, reloc);
> +
> +	if (is_string_sec(sym->sec)) {
> +		char *str;
> +
> +		str =3D sym->sec->data->d_buf + sym->offset + offset;
> +		checksum_update(func, insn, str, strlen(str));
> +		return;
> +	}
> +
> +	if (is_sec_sym(sym)) {
> +		sym =3D find_symbol_containing(reloc->sym->sec, offset);
> +		if (!sym)
> +			return;
> +
> +		offset -=3D sym->offset;
> +	}
> +
> +	checksum_update(func, insn, sym->demangled_name, strlen(sym-
> >demangled_name));
> +	checksum_update(func, insn, &offset, sizeof(offset));
> +}
> +
>  /*
>   * Follow the branch starting at the given instruction, and recursively =
follow
>   * any other branches (jumps).  Meanwhile, track the frame pointer state=
 at
> @@ -3547,6 +3654,9 @@ static int validate_branch(struct objtool_file *fil=
e, struct
> symbol *func,
>  	while (1) {
>  		next_insn =3D next_insn_to_validate(file, insn);
>=20
> +		if (opts.checksum && func && insn->sec)
> +			checksum_update_insn(file, func, insn);
> +
>  		if (func && insn_func(insn) && func !=3D insn_func(insn)->pfunc) {
>  			/* Ignore KCFI type preambles, which always fall through */
>  			if (is_prefix_func(func))
> @@ -3796,7 +3906,13 @@ static int validate_unwind_hint(struct objtool_fil=
e *file,
>  				  struct insn_state *state)
>  {
>  	if (insn->hint && !insn->visited) {
> -		int ret =3D validate_branch(file, insn_func(insn), insn, *state);
> +		struct symbol *func =3D insn_func(insn);
> +		int ret;
> +
> +		if (opts.checksum)
> +			checksum_init(func);
> +
> +		ret =3D validate_branch(file, func, insn, *state);
>  		if (ret)
>  			BT_INSN(insn, "<=3D=3D=3D (hint)");
>  		return ret;
> @@ -4175,6 +4291,7 @@ static int validate_symbol(struct objtool_file *fil=
e, struct
> section *sec,
>  			   struct symbol *sym, struct insn_state *state)
>  {
>  	struct instruction *insn;
> +	struct symbol *func;
>  	int ret;
>=20
>  	if (!sym->len) {
> @@ -4192,9 +4309,18 @@ static int validate_symbol(struct objtool_file *fi=
le, struct
> section *sec,
>  	if (opts.uaccess)
>  		state->uaccess =3D sym->uaccess_safe;
>=20
> -	ret =3D validate_branch(file, insn_func(insn), insn, *state);
> +	func =3D insn_func(insn);
> +
> +	if (opts.checksum)
> +		checksum_init(func);
> +
> +	ret =3D validate_branch(file, func, insn, *state);
>  	if (ret)
>  		BT_INSN(insn, "<=3D=3D=3D (sym)");
> +
> +	if (opts.checksum)
> +		checksum_finish(func);
> +
>  	return ret;
>  }
>=20
> @@ -4712,7 +4838,7 @@ int check(struct objtool_file *file)
>  	if (opts.retpoline)
>  		warnings +=3D validate_retpoline(file);
>=20
> -	if (opts.stackval || opts.orc || opts.uaccess) {
> +	if (validate_branch_enabled()) {
>  		int w =3D 0;
>=20
>  		w +=3D validate_functions(file);
> @@ -4791,6 +4917,12 @@ int check(struct objtool_file *file)
>  	if (opts.noabs)
>  		warnings +=3D check_abs_references(file);
>=20
> +	if (opts.checksum) {
> +		ret =3D create_sym_checksum_section(file);
> +		if (ret)
> +			goto out;
> +	}
> +
>  	if (opts.orc && nr_insns) {
>  		ret =3D orc_create(file);
>  		if (ret)
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index 6095baba8e9c5..0119b3b4c5540 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -17,6 +17,7 @@
>  #include <unistd.h>
>  #include <errno.h>
>  #include <libgen.h>
> +#include <ctype.h>
>  #include <linux/interval_tree_generic.h>
>  #include <objtool/builtin.h>
>  #include <objtool/elf.h>
> @@ -412,7 +413,38 @@ static int read_sections(struct elf *elf)
>  	return 0;
>  }
>=20
> -static void elf_add_symbol(struct elf *elf, struct symbol *sym)
> +static const char *demangle_name(struct symbol *sym)
> +{
> +	char *str;
> +
> +	if (!is_local_sym(sym))
> +		return sym->name;
> +
> +	if (!is_func_sym(sym) && !is_object_sym(sym))
> +		return sym->name;
> +
> +	if (!strstarts(sym->name, "__UNIQUE_ID_") && !strchr(sym->name, '.'))
> +		return sym->name;
> +
> +	str =3D strdup(sym->name);
> +	if (!str) {
> +		ERROR_GLIBC("strdup");
> +		return NULL;
> +	}
> +
> +	for (int i =3D strlen(str) - 1; i >=3D 0; i--) {
> +		char c =3D str[i];
> +
> +		if (!isdigit(c) && c !=3D '.') {
> +			str[i + 1] =3D '\0';
> +			break;
> +		}
> +	};
> +
> +	return str;
> +}
> +
> +static int elf_add_symbol(struct elf *elf, struct symbol *sym)
>  {
>  	struct list_head *entry;
>  	struct rb_node *pnode;
> @@ -456,6 +488,12 @@ static void elf_add_symbol(struct elf *elf, struct s=
ymbol *sym)
>  	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
>  		sym->cold =3D 1;
>  	sym->pfunc =3D sym->cfunc =3D sym;
> +
> +	sym->demangled_name =3D demangle_name(sym);
> +	if (!sym->demangled_name)
> +		return -1;
> +
> +	return 0;
>  }
>=20
>  static int read_symbols(struct elf *elf)
> @@ -529,7 +567,8 @@ static int read_symbols(struct elf *elf)
>  		} else
>  			sym->sec =3D find_section_by_index(elf, 0);
>=20
> -		elf_add_symbol(elf, sym);
> +		if (elf_add_symbol(elf, sym))
> +			return -1;
>  	}
>=20
>  	if (opts.stats) {
> @@ -867,7 +906,8 @@ struct symbol *elf_create_symbol(struct elf *elf, con=
st char
> *name,
>  		mark_sec_changed(elf, symtab_shndx, true);
>  	}
>=20
> -	elf_add_symbol(elf, sym);
> +	if (elf_add_symbol(elf, sym))
> +		return NULL;
>=20
>  	return sym;
>  }
> diff --git a/tools/objtool/include/objtool/builtin.h
> b/tools/objtool/include/objtool/builtin.h
> index 7d559a2c13b7b..338bdab6b9ad8 100644
> --- a/tools/objtool/include/objtool/builtin.h
> +++ b/tools/objtool/include/objtool/builtin.h
> @@ -9,12 +9,15 @@
>=20
>  struct opts {
>  	/* actions: */
> +	bool cfi;
> +	bool checksum;
>  	bool dump_orc;
>  	bool hack_jump_label;
>  	bool hack_noinstr;
>  	bool hack_skylake;
>  	bool ibt;
>  	bool mcount;
> +	bool noabs;
>  	bool noinstr;
>  	bool orc;
>  	bool retpoline;
> @@ -25,8 +28,6 @@ struct opts {
>  	bool static_call;
>  	bool uaccess;
>  	int prefix;
> -	bool cfi;
> -	bool noabs;
>=20
>  	/* options: */
>  	bool backtrace;
> diff --git a/tools/objtool/include/objtool/check.h
> b/tools/objtool/include/objtool/check.h
> index 0f4e7ac929ef0..d73b0c3ae1ee3 100644
> --- a/tools/objtool/include/objtool/check.h
> +++ b/tools/objtool/include/objtool/check.h
> @@ -65,8 +65,9 @@ struct instruction {
>  	    unret		: 1,
>  	    visited		: 4,
>  	    no_reloc		: 1,
> -	    hole		: 1;
> -		/* 10 bit hole */
> +	    hole		: 1,
> +	    fake		: 1;
> +		/* 9 bit hole */
>=20
>  	struct alt_group *alt_group;
>  	struct instruction *jump_dest;
> diff --git a/tools/objtool/include/objtool/checksum.h
> b/tools/objtool/include/objtool/checksum.h
> new file mode 100644
> index 0000000000000..927ca74b5c39e
> --- /dev/null
> +++ b/tools/objtool/include/objtool/checksum.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _OBJTOOL_CHECKSUM_H
> +#define _OBJTOOL_CHECKSUM_H
> +
> +#include <objtool/elf.h>
> +
> +#ifdef BUILD_KLP
> +
> +static inline void checksum_init(struct symbol *func)
> +{
> +	if (func && !func->csum.state) {
> +		func->csum.state =3D XXH3_createState();
> +		XXH3_64bits_reset(func->csum.state);
> +	}
> +}
> +
> +static inline void checksum_update(struct symbol *func,
> +				   struct instruction *insn,
> +				   const void *data, size_t size)
> +{
> +	XXH3_64bits_update(func->csum.state, data, size);
> +}
> +
> +static inline void checksum_finish(struct symbol *func)
> +{
> +	if (func && func->csum.state) {
> +		func->csum.checksum =3D XXH3_64bits_digest(func->csum.state);
> +		func->csum.state =3D NULL;
> +	}
> +}
> +
> +#else /* !BUILD_KLP */
> +
> +static inline void checksum_init(struct symbol *func) {}
> +static inline void checksum_update(struct symbol *func,
> +				   struct instruction *insn,
> +				   const void *data, size_t size) {}
> +static inline void checksum_finish(struct symbol *func) {}
> +
> +#endif /* !BUILD_KLP */
> +
> +#endif /* _OBJTOOL_CHECKSUM_H */
> diff --git a/tools/objtool/include/objtool/checksum_types.h
> b/tools/objtool/include/objtool/checksum_types.h
> new file mode 100644
> index 0000000000000..507efdd8ab5b9
> --- /dev/null
> +++ b/tools/objtool/include/objtool/checksum_types.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _OBJTOOL_CHECKSUM_TYPES_H
> +#define _OBJTOOL_CHECKSUM_TYPES_H
> +
> +struct sym_checksum {
> +	u64 addr;
> +	u64 checksum;
> +};
> +
> +#ifdef BUILD_KLP
> +
> +#include <xxhash.h>
> +
> +struct checksum {
> +	XXH3_state_t *state;
> +	XXH64_hash_t checksum;
> +};
> +
> +#else /* !BUILD_KLP */
> +
> +struct checksum {};
> +
> +#endif /* !BUILD_KLP */
> +
> +#endif /* _OBJTOOL_CHECKSUM_TYPES_H */
> diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/=
objtool/elf.h
> index 814cfc0bbf16b..bc7d8a6167f8f 100644
> --- a/tools/objtool/include/objtool/elf.h
> +++ b/tools/objtool/include/objtool/elf.h
> @@ -15,6 +15,7 @@
>  #include <linux/jhash.h>
>=20
>  #include <objtool/endianness.h>
> +#include <objtool/checksum_types.h>
>  #include <arch/elf.h>
>=20
>  #define SYM_NAME_LEN		512
> @@ -61,7 +62,7 @@ struct symbol {
>  	struct elf_hash_node name_hash;
>  	GElf_Sym sym;
>  	struct section *sec;
> -	const char *name;
> +	const char *name, *demangled_name;
>  	unsigned int idx, len;
>  	unsigned long offset;
>  	unsigned long __subtree_last;
> @@ -84,6 +85,7 @@ struct symbol {
>  	struct list_head pv_target;
>  	struct reloc *relocs;
>  	struct section *group_sec;
> +	struct checksum csum;
>  };
>=20
>  struct reloc {
> --
> 2.50.0
>=20


