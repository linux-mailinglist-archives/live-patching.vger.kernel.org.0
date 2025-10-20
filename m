Return-Path: <live-patching+bounces-1767-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A84BF2758
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 18:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3CAF84E7167
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 16:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B69299AAC;
	Mon, 20 Oct 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="En1o81u5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE46A28DB54;
	Mon, 20 Oct 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978069; cv=none; b=q41xXItHOb7wUjdVPyJFeXAiAurHBdfmSbysUevLHnIiHVhkUTfnWFASRjLT8h7NgSP/VG7VqsCttvalU7nl1/Zz2yXVOz6Kyrp33+XtX3ykIUt0Ipq7R5z46pmN6pq6aanhV4L53zd3GXypspum7BPdV71jKIRWBNf4DqxeJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978069; c=relaxed/simple;
	bh=GTzcWsBngBKSLdqbdy3znkFcZPFS8ulU3PcKG3gyTp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBEPPsUz2X2jTRJPFxqiYsDM6C81Ylkp+irBhTSQ8C7fO0lbAV+gSrl+otb1FxsXC/fp+O4KGgdU+prNqfTDXG2WQDA5lIczOlN9v0ulinKv1ELtESigQaQw2mkQf6loHhE3DPVczXaYzCtSp33C8EvbQFn2iTOg763BfBpScwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=En1o81u5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEB1C4CEF9;
	Mon, 20 Oct 2025 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760978069;
	bh=GTzcWsBngBKSLdqbdy3znkFcZPFS8ulU3PcKG3gyTp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=En1o81u5F15QM/MGvNHDr1pXb9paDqCbGDlJ2dRIOWzF64j8aRJeyXmlb+tTvnVWi
	 k90fd2dm8hmVTlz31UdFl6RTnNh+58IXBLvV1tTPZeg9k7EgxEuJJcdf1a2NhjZqJZ
	 taEThccZhnbFd5wiWKPM5wG2z3lIDe/4K/ZBV6r53kiZ/ELKBuggItPtiHzcBwgiOy
	 JmzeA2kvHUxOTbMcFTW3EW0EJow/18FJT85Us0BGjOmeyleinZDfp9G5h0NAeG1zHo
	 Yc2800DtfZmibowqiyZACXF/RQ2D36j0/KJf6OB9dGoKqCVz5jAfGrWPnn3+qOFsSp
	 pEL5luegzriwg==
Date: Mon, 20 Oct 2025 17:34:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v4 08/63] kbuild: Remove 'kmod_' prefix from
 __KBUILD_MODNAME
Message-ID: <4bdb7ac2-b24e-4906-aafa-4224c0ec11d2@sirena.org.uk>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SUQWfq5K/e5rbqad"
Content-Disposition: inline
In-Reply-To: <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
X-Cookie: Happy feast of the pig!


--SUQWfq5K/e5rbqad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 09:03:16AM -0700, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, remove the arbitrary
> 'kmod_' prefix from __KBUILD_MODNAME and instead add it explicitly in
> the __initcall_id() macro.

I'll add my name to the list of people reporting that this is causing
extensive breakage in -next, anything that tries to load modules has a
bad time which takes out a lot of tests.

Sample bisect log:

# bad: [606da5bb165594c052ee11de79bf05bc38bc1aa6] Add linux-next specific f=
iles for 20251020
# good: [4d7f6adc7b72e14c0f2646a4abb79bb6cc676ada] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [211ddde0823f1442e4ad052a2f30f050145ccada] Linux 6.18-rc2
# good: [0cdb2b1b7edaefb54773d790c7b5c2e4ac7db60d] spi: airoha: driver fixe=
s & improvements
# good: [0743acf746a81e0460a56fd5ff847d97fa7eb370] spi: airoha: buffer must=
 be 0xff-ed before writing
# good: [661856ca131c8bf6724905966e02149805660abe] spi: airoha: remove unne=
cessary restriction length
# good: [70eec454f2d6cdfab547c262781acd38328e11a1] spi: airoha: avoid setti=
ng of page/oob sizes in REG_SPI_NFI_PAGEFMT
# good: [d1ff30df1d9a4eb4c067795abb5e2a66910fd108] spi: airoha: reduce the =
number of modification of REG_SPI_NFI_CNFG and REG_SPI_NFI_SECCUS_SIZE regi=
sters
# good: [fb81b5cecb8553e3ca2b45288cf340d43c9c2991] spi: airoha: set custom =
sector size equal to flash page size
# good: [902c0ea18a97b1a6eeee5799cb1fd9a79ef9208e] spi: airoha: avoid readi=
ng flash page settings from SNFI registers during driver startup
# good: [80b09137aeab27e59004383058f8cc696a9ee048] spi: airoha: support of =
dualio/quadio flash reading commands
# good: [0cc08c8130ac8f74419f99fe707dc193b7f79d86] spi: aspeed: Fix an IS_E=
RR() vs NULL bug in probe()
# good: [93b2838c6e79bc263e6129d88c5ab043dd793d28] Add Audio Support for Ka=
anapali MTP Boards
# good: [233a22687411ea053a4b169c07324ee6aa33bf38] spi: airoha: unify dirma=
p read/write code
# good: [7350f8dc15bfbb7abf1ce4babea6fcace1c574c5] spi: airoha: remove unne=
cessary switch to non-dma mode
# good: [5263cd81578f99a00b2dd7de1da2b570b96a1b7c] rpmh-regulators: Update =
rpmh-regulator driver and
# good: [281c97376cfcfc8cef4f5ed5dd961a1b39f5a25e] ASoC: codecs: va-macro: =
Rework version checking
# good: [d77daa49085b067137d0adbe3263f75a7ee13a1b] spi: aspeed: fix spellin=
g mistake "triming" -> "trimming"
# good: [4673dbe9837e3eb2fecdd12f0953006c31636aac] ASoC: qcom: sc8280xp: Ad=
d support for Kaanapali
# good: [367ca0688e4218e51c3d4dfdf3ef5657a62cf88d] ASoC: dt-bindings: qcom,=
sm8250: Add kaanapali sound card
# good: [15afe57a874eaf104bfbb61ec598fa31627f7b19] ASoC: dt-bindings: qcom:=
 Add Kaanapali LPASS macro codecs
# good: [1e570e77392f43a3cdab2849d1f81535f8a033e2] ASoC: mxs-saif: support =
usage with simple-audio-card
# good: [1356c98ef911e14ccfaf374800840ce5bdcb3bbd] regulator: dt-bindings: =
rpmh-regulator: Update pmic-id DT prop info for new CMD-DB
# good: [fb25114cd760c13cf177d9ac37837fafcc9657b5] regulator: sy7636a: add =
gpios and input regulator
# good: [835dfb12fc389f36eb007657f163bd1c539dcd45] regulator: dt-bindings: =
rpmh-regulator : Add compatibles for PMH01XX & PMCX0102
# good: [65efe5404d151767653c7b7dd39bd2e7ad532c2d] regulator: rpmh-regulato=
r: Add RPMH regulator support for Glymur
# good: [6621b0f118d500092f5f3d72ddddb22aeeb3c3a0] ASoC: codecs: rt5670: us=
e SOC_VALUE_ENUM_SINGLE_DECL for DAC2 L/R MX-1B
# good: [6a8cdef7dc2a4c0dbde3f7d7100b3d99712a766b] regulator: rpmh-regulato=
r: Add support for new resource name format
# good: [cee2c8396d9c8e834fe28929bc1d8153d7e9897f] ASoC: use sof_sdw as def=
ault Intel SOF SDW machine
# good: [7d9c2924f61dcabcbc5868bec6054ab4f4de01d1] spi: aspeed: Improve clo=
ck, timing and address
# good: [79c36ecfc8994011ab0a973d3b4148aa5d9e0c91] ASoC: use sof_sdw as def=
ault Intel SOF SDW machine
# good: [433e294c3c5b5d2020085a0e36c1cb47b694690a] regulator: core: forward=
 undervoltage events downstream by default
# good: [0b0eb7702a9fa410755e86124b4b7cd36e7d1cb4] ASoC: replace use of sys=
tem_wq with system_dfl_wq
# good: [92a42edd347c3b5a9045bb137a33204c6ddc0803] Add target mode support =
for the DesignWare SPI
# good: [c1afb0350069c3be137b5692923ad13d69648970] Add tegra264 audio devic=
e tree support
# good: [a758314f71ba90cca2a5813bbf96c4954a15b613] spi: offload: Add offset=
 parameter
# good: [506cbe36a2ac7b504a2362476dc53cd548b7a29e] ASoC: soc_sdw_utils: exp=
ort asoc_sdw_get_dai_type
# good: [225d70b8074502acee3943bf0c2e839e867cd38c] ASoC: SOF: don't check t=
he existence of dummy topology
# good: [55f8b5a96597a7b88c323a7de7228f9eae8c9943] ASoC: Intel: export sof_=
sdw_get_tplg_files
# good: [7e7e2c6e2a1cb250f8d03bb99eed01f6d982d5dd] ASoC: sof-function-topol=
ogy-lib: escalate the log when missing function topoplogy
# good: [bb940b13998c40d55e186f0cf5d65c592ea1677a] ASoC: SOF: Don't print t=
he monolithic topology name if function topology may be used
# good: [aa1ee85ce3576defd29f2a389d7508d2036af977] ASoC: soc_sdw_utils: add=
 name_prefix to asoc_sdw_codec_info struct
# good: [7f47685b150dbc20f881d029a7366a81b1d66322] ASoC: SOF: Intel: use so=
f_sdw as default SDW machine driver
# good: [3180c7b1575d635851f0ceab6bdb176bb15e69dd] ASoC: soc-acpi: make som=
e variables of acpi adr and link adr non-const
# good: [0d202ae0256e8e7dcea862ead5904fa27cf4ce6a] ASoC: SOF: add platform =
name into sof_intel_dsp_desc
# good: [2b92b98cc4765fbb0748742e7e0dd94d15d6f178] ASoC: SOF: Don't print t=
he monolithic topology name if function topology may be used
# good: [6277a486a7faaa6c87f4bf1d59a2de233a093248] regulator: dt-bindings: =
Convert Dialog DA9211 Regulators to DT schema
# good: [454cd43a283f7697297c52981c7a499a16725656] spi: dt-bindings: spi-qp=
ic-snand: Add IPQ5424 compatible
# good: [6937ff42f28a13ffdbe2d1f5b9a51a35f626e93a] ASoC: SOF: add platform =
name into sof_intel_dsp_desc
# good: [b926b15547d29a88932de3c24a05c12826fc1dbc] spi: dw: rename the spi =
controller to ctlr
# good: [7196fc4e482928a276da853e2687f31cd8ea2611] ASoC: Intel: export sof_=
sdw_get_tplg_files
# good: [d25de16477657f9eddd4be9abd409515edcc3b9e] ASoC: soc-acpi: make som=
e variables of acpi adr and link adr non-const
# good: [630a185fd06109193574d10f38b29812986c21de] spi: aspeed: Force defau=
lt address decoding range assignment for each CS
# good: [5226d19d4cae5398caeb93a6052bfb614e0099c7] ASoC: SOF: Intel: use so=
f_sdw as default SDW machine driver
# good: [31dcc7e1f8a9377d8fd9f967f84c121c5ba8f89c] spi: aspeed: Update cloc=
k selection strategy
# good: [9797329220a2c6622411eb9ecf6a35b24ce09d04] ASoC: sof-function-topol=
ogy-lib: escalate the log when missing function topoplogy
# good: [ea97713903784286ef1ce45456f404ed288f19b1] ASoC: soc_sdw_utils: add=
 name_prefix to asoc_sdw_codec_info struct
# good: [4ebe64f507ca921c5109eb37eae6058b77413d93] ASoC: tas2781: Add TAS58=
02, TAS5815, and TAS5828
# good: [5ed60e45c59d66e61586a10433e2b5527d4d72b5] ASoC: soc_sdw_utils: exp=
ort asoc_sdw_get_dai_type
# good: [b83fb1b14c06bdd765903ac852ba20a14e24f227] spi: offload: Add offset=
 parameter
# good: [4d410ba9aa275e7990a270f63ce436990ace1bea] dt-bindings: sound: Upda=
te ADMAIF bindings for tegra264
# good: [29fa213c6ab00c6749db47b47e384cab760c109e] ASoC: dt-bindings: ti,ta=
s2781: Add TAS5802, TAS5815, and TAS5828
# good: [99c159279c6dfa2c4867c7f76875f58263f8f43b] ASoC: SOF: don't check t=
he existence of dummy topology
# good: [0586b53d4a0c7c5a132629f99da934cc674ea4cd] spi: aspeed: Add per-pla=
tform adjust_window callback for decoding range
# good: [3c89238ca35bfe176ba34bc688541f90f6fa7bdb] ASoc: tas2783A: Remove u=
nneeded variable assignment
# good: [5e537031f322d55315cd384398b726a9a0748d47] ASoC: codecs: Fix the er=
ror of excessive semicolons
# good: [4412ab501677606436e5c49e41151a1e6eac7ac0] spi: dt-bindings: spi-qp=
ic-snand: Add IPQ5332 compatible
# good: [efb79de36e947d136517bac14c139d494fcc72fa] spi: aspeed: Improve tim=
ing calibration algorithm for AST2600 platform
# good: [fe8cc44dd173cde5788ab4e3730ac61f3d316d9c] spi: dw: add target mode=
 support
# good: [64d87ccfae3326a9561fe41dc6073064a083e0df] spi: aspeed: Only map ne=
cessary address window region
# good: [be2ba2fef1676861b295053c2a567b057e9031b9] bugs/sh: Concatenate 'co=
nd_str' with '__FILE__' in __WARN_FLAGS(), to extend WARN_ON/BUG_ON output
# good: [6c177775dcc5e70a64ddf4ee842c66af498f2c7c] Merge branch 'next/drive=
rs' into for-next
# good: [da15636d84a812275f785057451c0e7b15b39012] Merge branch 'v6.18/arm6=
4-dt' into for-next
# good: [06dd3eda0e958cdae48ca755eb5047484f678d78] Merge branch 'vfs-6.18.r=
ust' into vfs.all
# good: [6dde339a3df80a57ac3d780d8cfc14d9262e2acd] landlock: Minor comments=
 improvements
# good: [447c98c1ca4a4b0d43be99f76c558c09956484f3] tools/power turbostat: A=
dd idle governor statistics reporting
# good: [3778dcb2dcc1ce03a2b25e5d951fe9912e843d1e] random: use offstack cpu=
mask when necessary
# good: [6684aba0780da9f505c202f27e68ee6d18c0aa66] XArray: Add extra debugg=
ing check to xas_lock and friends
git bisect start '606da5bb165594c052ee11de79bf05bc38bc1aa6' '4d7f6adc7b72e1=
4c0f2646a4abb79bb6cc676ada' '211ddde0823f1442e4ad052a2f30f050145ccada' '0cd=
b2b1b7edaefb54773d790c7b5c2e4ac7db60d' '0743acf746a81e0460a56fd5ff847d97fa7=
eb370' '661856ca131c8bf6724905966e02149805660abe' '70eec454f2d6cdfab547c262=
781acd38328e11a1' 'd1ff30df1d9a4eb4c067795abb5e2a66910fd108' 'fb81b5cecb855=
3e3ca2b45288cf340d43c9c2991' '902c0ea18a97b1a6eeee5799cb1fd9a79ef9208e' '80=
b09137aeab27e59004383058f8cc696a9ee048' '0cc08c8130ac8f74419f99fe707dc193b7=
f79d86' '93b2838c6e79bc263e6129d88c5ab043dd793d28' '233a22687411ea053a4b169=
c07324ee6aa33bf38' '7350f8dc15bfbb7abf1ce4babea6fcace1c574c5' '5263cd81578f=
99a00b2dd7de1da2b570b96a1b7c' '281c97376cfcfc8cef4f5ed5dd961a1b39f5a25e' 'd=
77daa49085b067137d0adbe3263f75a7ee13a1b' '4673dbe9837e3eb2fecdd12f0953006c3=
1636aac' '367ca0688e4218e51c3d4dfdf3ef5657a62cf88d' '15afe57a874eaf104bfbb6=
1ec598fa31627f7b19' '1e570e77392f43a3cdab2849d1f81535f8a033e2' '1356c98ef91=
1e14ccfaf374800840ce5bdcb3bbd' 'fb25114cd760c13cf177d9ac37837fafcc9657b5' '=
835dfb12fc389f36eb007657f163bd1c539dcd45' '65efe5404d151767653c7b7dd39bd2e7=
ad532c2d' '6621b0f118d500092f5f3d72ddddb22aeeb3c3a0' '6a8cdef7dc2a4c0dbde3f=
7d7100b3d99712a766b' 'cee2c8396d9c8e834fe28929bc1d8153d7e9897f' '7d9c2924f6=
1dcabcbc5868bec6054ab4f4de01d1' '79c36ecfc8994011ab0a973d3b4148aa5d9e0c91' =
'433e294c3c5b5d2020085a0e36c1cb47b694690a' '0b0eb7702a9fa410755e86124b4b7cd=
36e7d1cb4' '92a42edd347c3b5a9045bb137a33204c6ddc0803' 'c1afb0350069c3be137b=
5692923ad13d69648970' 'a758314f71ba90cca2a5813bbf96c4954a15b613' '506cbe36a=
2ac7b504a2362476dc53cd548b7a29e' '225d70b8074502acee3943bf0c2e839e867cd38c'=
 '55f8b5a96597a7b88c323a7de7228f9eae8c9943' '7e7e2c6e2a1cb250f8d03bb99eed01=
f6d982d5dd' 'bb940b13998c40d55e186f0cf5d65c592ea1677a' 'aa1ee85ce3576defd29=
f2a389d7508d2036af977' '7f47685b150dbc20f881d029a7366a81b1d66322' '3180c7b1=
575d635851f0ceab6bdb176bb15e69dd' '0d202ae0256e8e7dcea862ead5904fa27cf4ce6a=
' '2b92b98cc4765fbb0748742e7e0dd94d15d6f178' '6277a486a7faaa6c87f4bf1d59a2d=
e233a093248' '454cd43a283f7697297c52981c7a499a16725656' '6937ff42f28a13ffdb=
e2d1f5b9a51a35f626e93a' 'b926b15547d29a88932de3c24a05c12826fc1dbc' '7196fc4=
e482928a276da853e2687f31cd8ea2611' 'd25de16477657f9eddd4be9abd409515edcc3b9=
e' '630a185fd06109193574d10f38b29812986c21de' '5226d19d4cae5398caeb93a6052b=
fb614e0099c7' '31dcc7e1f8a9377d8fd9f967f84c121c5ba8f89c' '9797329220a2c6622=
411eb9ecf6a35b24ce09d04' 'ea97713903784286ef1ce45456f404ed288f19b1' '4ebe64=
f507ca921c5109eb37eae6058b77413d93' '5ed60e45c59d66e61586a10433e2b5527d4d72=
b5' 'b83fb1b14c06bdd765903ac852ba20a14e24f227' '4d410ba9aa275e7990a270f63ce=
436990ace1bea' '29fa213c6ab00c6749db47b47e384cab760c109e' '99c159279c6dfa2c=
4867c7f76875f58263f8f43b' '0586b53d4a0c7c5a132629f99da934cc674ea4cd' '3c892=
38ca35bfe176ba34bc688541f90f6fa7bdb' '5e537031f322d55315cd384398b726a9a0748=
d47' '4412ab501677606436e5c49e41151a1e6eac7ac0' 'efb79de36e947d136517bac14c=
139d494fcc72fa' 'fe8cc44dd173cde5788ab4e3730ac61f3d316d9c' '64d87ccfae3326a=
9561fe41dc6073064a083e0df' 'be2ba2fef1676861b295053c2a567b057e9031b9' '6c17=
7775dcc5e70a64ddf4ee842c66af498f2c7c' 'da15636d84a812275f785057451c0e7b15b3=
9012' '06dd3eda0e958cdae48ca755eb5047484f678d78' '6dde339a3df80a57ac3d780d8=
cfc14d9262e2acd' '447c98c1ca4a4b0d43be99f76c558c09956484f3' '3778dcb2dcc1ce=
03a2b25e5d951fe9912e843d1e' '6684aba0780da9f505c202f27e68ee6d18c0aa66'
# test job: [211ddde0823f1442e4ad052a2f30f050145ccada] https://lava.sirena.=
org.uk/scheduler/job/1976562
# test job: [0cdb2b1b7edaefb54773d790c7b5c2e4ac7db60d] https://lava.sirena.=
org.uk/scheduler/job/1965930
# test job: [0743acf746a81e0460a56fd5ff847d97fa7eb370] https://lava.sirena.=
org.uk/scheduler/job/1964854
# test job: [661856ca131c8bf6724905966e02149805660abe] https://lava.sirena.=
org.uk/scheduler/job/1965121
# test job: [70eec454f2d6cdfab547c262781acd38328e11a1] https://lava.sirena.=
org.uk/scheduler/job/1964899
# test job: [d1ff30df1d9a4eb4c067795abb5e2a66910fd108] https://lava.sirena.=
org.uk/scheduler/job/1965054
# test job: [fb81b5cecb8553e3ca2b45288cf340d43c9c2991] https://lava.sirena.=
org.uk/scheduler/job/1965035
# test job: [902c0ea18a97b1a6eeee5799cb1fd9a79ef9208e] https://lava.sirena.=
org.uk/scheduler/job/1964990
# test job: [80b09137aeab27e59004383058f8cc696a9ee048] https://lava.sirena.=
org.uk/scheduler/job/1965075
# test job: [0cc08c8130ac8f74419f99fe707dc193b7f79d86] https://lava.sirena.=
org.uk/scheduler/job/1965700
# test job: [93b2838c6e79bc263e6129d88c5ab043dd793d28] https://lava.sirena.=
org.uk/scheduler/job/1964758
# test job: [233a22687411ea053a4b169c07324ee6aa33bf38] https://lava.sirena.=
org.uk/scheduler/job/1965101
# test job: [7350f8dc15bfbb7abf1ce4babea6fcace1c574c5] https://lava.sirena.=
org.uk/scheduler/job/1965137
# test job: [5263cd81578f99a00b2dd7de1da2b570b96a1b7c] https://lava.sirena.=
org.uk/scheduler/job/1964744
# test job: [281c97376cfcfc8cef4f5ed5dd961a1b39f5a25e] https://lava.sirena.=
org.uk/scheduler/job/1962783
# test job: [d77daa49085b067137d0adbe3263f75a7ee13a1b] https://lava.sirena.=
org.uk/scheduler/job/1962822
# test job: [4673dbe9837e3eb2fecdd12f0953006c31636aac] https://lava.sirena.=
org.uk/scheduler/job/1962868
# test job: [367ca0688e4218e51c3d4dfdf3ef5657a62cf88d] https://lava.sirena.=
org.uk/scheduler/job/1962854
# test job: [15afe57a874eaf104bfbb61ec598fa31627f7b19] https://lava.sirena.=
org.uk/scheduler/job/1962908
# test job: [1e570e77392f43a3cdab2849d1f81535f8a033e2] https://lava.sirena.=
org.uk/scheduler/job/1962270
# test job: [1356c98ef911e14ccfaf374800840ce5bdcb3bbd] https://lava.sirena.=
org.uk/scheduler/job/1959898
# test job: [fb25114cd760c13cf177d9ac37837fafcc9657b5] https://lava.sirena.=
org.uk/scheduler/job/1960171
# test job: [835dfb12fc389f36eb007657f163bd1c539dcd45] https://lava.sirena.=
org.uk/scheduler/job/1959997
# test job: [65efe5404d151767653c7b7dd39bd2e7ad532c2d] https://lava.sirena.=
org.uk/scheduler/job/1959947
# test job: [6621b0f118d500092f5f3d72ddddb22aeeb3c3a0] https://lava.sirena.=
org.uk/scheduler/job/1959730
# test job: [6a8cdef7dc2a4c0dbde3f7d7100b3d99712a766b] https://lava.sirena.=
org.uk/scheduler/job/1959863
# test job: [cee2c8396d9c8e834fe28929bc1d8153d7e9897f] https://lava.sirena.=
org.uk/scheduler/job/1959137
# test job: [7d9c2924f61dcabcbc5868bec6054ab4f4de01d1] https://lava.sirena.=
org.uk/scheduler/job/1957764
# test job: [79c36ecfc8994011ab0a973d3b4148aa5d9e0c91] https://lava.sirena.=
org.uk/scheduler/job/1959155
# test job: [433e294c3c5b5d2020085a0e36c1cb47b694690a] https://lava.sirena.=
org.uk/scheduler/job/1957349
# test job: [0b0eb7702a9fa410755e86124b4b7cd36e7d1cb4] https://lava.sirena.=
org.uk/scheduler/job/1957419
# test job: [92a42edd347c3b5a9045bb137a33204c6ddc0803] https://lava.sirena.=
org.uk/scheduler/job/1957776
# test job: [c1afb0350069c3be137b5692923ad13d69648970] https://lava.sirena.=
org.uk/scheduler/job/1959166
# test job: [a758314f71ba90cca2a5813bbf96c4954a15b613] https://lava.sirena.=
org.uk/scheduler/job/1957731
# test job: [506cbe36a2ac7b504a2362476dc53cd548b7a29e] https://lava.sirena.=
org.uk/scheduler/job/1954111
# test job: [225d70b8074502acee3943bf0c2e839e867cd38c] https://lava.sirena.=
org.uk/scheduler/job/1954369
# test job: [55f8b5a96597a7b88c323a7de7228f9eae8c9943] https://lava.sirena.=
org.uk/scheduler/job/1954364
# test job: [7e7e2c6e2a1cb250f8d03bb99eed01f6d982d5dd] https://lava.sirena.=
org.uk/scheduler/job/1954346
# test job: [bb940b13998c40d55e186f0cf5d65c592ea1677a] https://lava.sirena.=
org.uk/scheduler/job/1954225
# test job: [aa1ee85ce3576defd29f2a389d7508d2036af977] https://lava.sirena.=
org.uk/scheduler/job/1954318
# test job: [7f47685b150dbc20f881d029a7366a81b1d66322] https://lava.sirena.=
org.uk/scheduler/job/1954198
# test job: [3180c7b1575d635851f0ceab6bdb176bb15e69dd] https://lava.sirena.=
org.uk/scheduler/job/1954125
# test job: [0d202ae0256e8e7dcea862ead5904fa27cf4ce6a] https://lava.sirena.=
org.uk/scheduler/job/1954349
# test job: [2b92b98cc4765fbb0748742e7e0dd94d15d6f178] https://lava.sirena.=
org.uk/scheduler/job/1947182
# test job: [6277a486a7faaa6c87f4bf1d59a2de233a093248] https://lava.sirena.=
org.uk/scheduler/job/1947002
# test job: [454cd43a283f7697297c52981c7a499a16725656] https://lava.sirena.=
org.uk/scheduler/job/1946525
# test job: [6937ff42f28a13ffdbe2d1f5b9a51a35f626e93a] https://lava.sirena.=
org.uk/scheduler/job/1947463
# test job: [b926b15547d29a88932de3c24a05c12826fc1dbc] https://lava.sirena.=
org.uk/scheduler/job/1947155
# test job: [7196fc4e482928a276da853e2687f31cd8ea2611] https://lava.sirena.=
org.uk/scheduler/job/1947424
# test job: [d25de16477657f9eddd4be9abd409515edcc3b9e] https://lava.sirena.=
org.uk/scheduler/job/1947441
# test job: [630a185fd06109193574d10f38b29812986c21de] https://lava.sirena.=
org.uk/scheduler/job/1947408
# test job: [5226d19d4cae5398caeb93a6052bfb614e0099c7] https://lava.sirena.=
org.uk/scheduler/job/1947447
# test job: [31dcc7e1f8a9377d8fd9f967f84c121c5ba8f89c] https://lava.sirena.=
org.uk/scheduler/job/1947173
# test job: [9797329220a2c6622411eb9ecf6a35b24ce09d04] https://lava.sirena.=
org.uk/scheduler/job/1947403
# test job: [ea97713903784286ef1ce45456f404ed288f19b1] https://lava.sirena.=
org.uk/scheduler/job/1947261
# test job: [4ebe64f507ca921c5109eb37eae6058b77413d93] https://lava.sirena.=
org.uk/scheduler/job/1946707
# test job: [5ed60e45c59d66e61586a10433e2b5527d4d72b5] https://lava.sirena.=
org.uk/scheduler/job/1947418
# test job: [b83fb1b14c06bdd765903ac852ba20a14e24f227] https://lava.sirena.=
org.uk/scheduler/job/1946831
# test job: [4d410ba9aa275e7990a270f63ce436990ace1bea] https://lava.sirena.=
org.uk/scheduler/job/1947842
# test job: [29fa213c6ab00c6749db47b47e384cab760c109e] https://lava.sirena.=
org.uk/scheduler/job/1946529
# test job: [99c159279c6dfa2c4867c7f76875f58263f8f43b] https://lava.sirena.=
org.uk/scheduler/job/1947475
# test job: [0586b53d4a0c7c5a132629f99da934cc674ea4cd] https://lava.sirena.=
org.uk/scheduler/job/1947341
# test job: [3c89238ca35bfe176ba34bc688541f90f6fa7bdb] https://lava.sirena.=
org.uk/scheduler/job/1946592
# test job: [5e537031f322d55315cd384398b726a9a0748d47] https://lava.sirena.=
org.uk/scheduler/job/1946678
# test job: [4412ab501677606436e5c49e41151a1e6eac7ac0] https://lava.sirena.=
org.uk/scheduler/job/1946586
# test job: [efb79de36e947d136517bac14c139d494fcc72fa] https://lava.sirena.=
org.uk/scheduler/job/1947142
# test job: [fe8cc44dd173cde5788ab4e3730ac61f3d316d9c] https://lava.sirena.=
org.uk/scheduler/job/1947055
# test job: [64d87ccfae3326a9561fe41dc6073064a083e0df] https://lava.sirena.=
org.uk/scheduler/job/1947243
# test job: [be2ba2fef1676861b295053c2a567b057e9031b9] https://lava.sirena.=
org.uk/scheduler/job/1738858
# test job: [6c177775dcc5e70a64ddf4ee842c66af498f2c7c] https://lava.sirena.=
org.uk/scheduler/job/1774070
# test job: [da15636d84a812275f785057451c0e7b15b39012] https://lava.sirena.=
org.uk/scheduler/job/1855168
# test job: [06dd3eda0e958cdae48ca755eb5047484f678d78] https://lava.sirena.=
org.uk/scheduler/job/1831740
# test job: [6dde339a3df80a57ac3d780d8cfc14d9262e2acd] https://lava.sirena.=
org.uk/scheduler/job/1647204
# test job: [447c98c1ca4a4b0d43be99f76c558c09956484f3] https://lava.sirena.=
org.uk/scheduler/job/1647256
# test job: [3778dcb2dcc1ce03a2b25e5d951fe9912e843d1e] https://lava.sirena.=
org.uk/scheduler/job/1676804
# test job: [6684aba0780da9f505c202f27e68ee6d18c0aa66] https://lava.sirena.=
org.uk/scheduler/job/1738724
# test job: [606da5bb165594c052ee11de79bf05bc38bc1aa6] https://lava.sirena.=
org.uk/scheduler/job/1976482
# bad: [606da5bb165594c052ee11de79bf05bc38bc1aa6] Add linux-next specific f=
iles for 20251020
git bisect bad 606da5bb165594c052ee11de79bf05bc38bc1aa6
# skip: [9a8ae3ba7a0d4467067d039a3eba8c0b0bd1c153] Merge branch 'libcrypto-=
next' of https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
git bisect skip 9a8ae3ba7a0d4467067d039a3eba8c0b0bd1c153
# test job: [9a4bbd20a879b66dddb563698345b0ae24d810a6] https://lava.sirena.=
org.uk/scheduler/job/1978205
# good: [9a4bbd20a879b66dddb563698345b0ae24d810a6] hwmon: (tmp108) Drop mut=
ex.h include
git bisect good 9a4bbd20a879b66dddb563698345b0ae24d810a6
# test job: [42277a1f86a14172c673a249bdc9e757065ca5a1] https://lava.sirena.=
org.uk/scheduler/job/1978413
# good: [42277a1f86a14172c673a249bdc9e757065ca5a1] Merge branch 'for-6.19' =
into for-next
git bisect good 42277a1f86a14172c673a249bdc9e757065ca5a1
# test job: [dd590d4d57ebeeb826823c288741f2ed20f452af] https://lava.sirena.=
org.uk/scheduler/job/1978495
# bad: [dd590d4d57ebeeb826823c288741f2ed20f452af] objtool/klp: Introduce kl=
p diff subcommand for diffing object files
git bisect bad dd590d4d57ebeeb826823c288741f2ed20f452af
# test job: [3e4b5f66cf1a7879a081f5044ff1796aa33cb999] https://lava.sirena.=
org.uk/scheduler/job/1978783
# bad: [3e4b5f66cf1a7879a081f5044ff1796aa33cb999] objtool: Check for missin=
g annotation entries in read_annotate()
git bisect bad 3e4b5f66cf1a7879a081f5044ff1796aa33cb999
# test job: [4109043bff31f95d3da9ace33eb3c1925fd62cbd] https://lava.sirena.=
org.uk/scheduler/job/1978959
# bad: [4109043bff31f95d3da9ace33eb3c1925fd62cbd] modpost: Ignore unresolve=
d section bounds symbols
git bisect bad 4109043bff31f95d3da9ace33eb3c1925fd62cbd
# test job: [1ba9f8979426590367406c70c1c821f5b943f993] https://lava.sirena.=
org.uk/scheduler/job/1979168
# good: [1ba9f8979426590367406c70c1c821f5b943f993] vmlinux.lds: Unify TEXT_=
MAIN, DATA_MAIN, and related macros
git bisect good 1ba9f8979426590367406c70c1c821f5b943f993
# test job: [9f14f1f91883aa2bfd6663161d2002c8ce937c43] https://lava.sirena.=
org.uk/scheduler/job/1979231
# good: [9f14f1f91883aa2bfd6663161d2002c8ce937c43] compiler.h: Make address=
able symbols less of an eyesore
git bisect good 9f14f1f91883aa2bfd6663161d2002c8ce937c43
# test job: [6717e8f91db71641cb52855ed14c7900972ed0bc] https://lava.sirena.=
org.uk/scheduler/job/1979182
# bad: [6717e8f91db71641cb52855ed14c7900972ed0bc] kbuild: Remove 'kmod_' pr=
efix from __KBUILD_MODNAME
git bisect bad 6717e8f91db71641cb52855ed14c7900972ed0bc
# test job: [c2d420796a427dda71a2400909864e7f8e037fd4] https://lava.sirena.=
org.uk/scheduler/job/1979307
# good: [c2d420796a427dda71a2400909864e7f8e037fd4] elfnote: Change ELFNOTE(=
) to use __UNIQUE_ID()
git bisect good c2d420796a427dda71a2400909864e7f8e037fd4
# first bad commit: [6717e8f91db71641cb52855ed14c7900972ed0bc] kbuild: Remo=
ve 'kmod_' prefix from __KBUILD_MODNAME

--SUQWfq5K/e5rbqad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj2ZIMACgkQJNaLcl1U
h9AQkgf+IpJMk8Bw2ncgLMov+9CE70NELCMVcpVkNWxwnRzQxxS95lIXiIrxRP+O
xDZjyiCVgC+0sNiDLOxJgMDzoy5JPf57LCCvJByp1laEE2eaD7Jud99eNitEDRxd
QUxNGp56yhkiTuoD1irWxC+uFl1Jre3uVcjS2ObMzJDdRCqJth/bVyTalJEqz8gm
vl9fXENXu/y7+TJld/y6Je+rONZ2h/tVNnToqkvwwBGFjwRyHnPo+u+pNU71947U
TIHBeKQclo/fkKL3aD0ZG2cBzFlyJtwVZk8IbRkq/VuRgaGTizChPe7Q4kyNXx3h
Q23MvV5FOakjkfrQzkrfz6gEgqK+wQ==
=5gKW
-----END PGP SIGNATURE-----

--SUQWfq5K/e5rbqad--

