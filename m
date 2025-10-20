Return-Path: <live-patching+bounces-1768-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA76CBF279A
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 18:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9C97A4F8E8D
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 16:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1014228EA72;
	Mon, 20 Oct 2025 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hg1aC1aW"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B76726F478
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978278; cv=none; b=iYQMQ/S62F4vwMUsOmoU9BvS70vOgyHNthcgagoWL/2y/3iWvjZiZgIQXBV+Cy1C6zX0XCt5dP+RvVTFG9mfXlTY2viyp7S7JchVB4Ti6Edc9zIxmo0QyzZEn34SogZj+AjA4/tpeGVWJG0HLc/HAShrHHJm4cd3Of+sRTb2uH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978278; c=relaxed/simple;
	bh=YEG62/zWI7JUwRcU7/VbqYXkIBeekZs85fRYRhzN+08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPSfsVewX2SUvNj8NodKGEG0wMXnjqHSqSDRmNgor9r8BBqo4v0/6UcpEnxbLm32VYuMT3+noTgpaaeOuvFvu83TUEoV+4cA5FcbJwHmmSJ2O0e2pZ6jgH0mXJfxmbpt8+QUl80aVHJF0P+qJ8SKek+eDLDw8NyVgIPWRbq41lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hg1aC1aW; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so2376391f8f.1
        for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 09:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760978275; x=1761583075; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8de+GbhMdW9I2uk7I+p7HUkd98yL0Pf24fRr/KS7HxY=;
        b=hg1aC1aWprRIR8snmgGxTdg5fXCGTABKkv63PYtDTqvGfsnhX+ei/4HsttKZD26ZyC
         nTMUSoWjQlb2Js2wk3fhQlHgcbYy8WoL4zRslNvCVqcx+CFl6Gcewy2WwyaUXsyemuCD
         Fqt2epiJ+BmmEShUwf9t/IAKhWhOpRF7oobDzSftBUvw3HBXKYvjLGAn6hNUlCNNJi03
         Th0fjpi4DZ/7OplpgLdj31Y/nAB3R7tGjbsFZ3ehcSrXOHx5xz58wMAC4E1YJ0Hut3V2
         3zFNHjJAYv7F84MWvHOUureNKQDhWi6bXbcY7Yl0ytGhdIR++JF5HBPHW4LKKMVb+qhl
         tK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978275; x=1761583075;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8de+GbhMdW9I2uk7I+p7HUkd98yL0Pf24fRr/KS7HxY=;
        b=L2E7qHTy7JuA7HAjCCoWlpZxEAsEurIH5fEE9ZWGkJVTssytWpIVJy6RxI0S6i7GLT
         4IL60mI/FQcB9qKPVIly5Kvg/l4sGeMu0VvcG0kQkayqCvK5YhusGND19n6HztlH9NBB
         Beuoj26hY8UlhAHQyy61VHwFif0KUoAWPyYyfa6vHHId3CpNX80kL/O7PXjls5NDuX+U
         X6YAv/oBXYn+mln3J10NiPkTeU9YbTfYGfxh+VOp1Dt2EAMq+m1pyypeUaZeqRR9va5a
         gz7c0Op2SjtisznXKiDoWpbm4mCyaK2904biNubEbh8il7qQl6WNUoWFknRBej/Ao5Ud
         CjKA==
X-Forwarded-Encrypted: i=1; AJvYcCUTXoeKwvd1Vdl54ojrjDd5jIC1kgNWm67yDmG8BgH1X0nIXKE8cTUd2wQymKrCNNPnOSHuL3gKyYV2RuGJ@vger.kernel.org
X-Gm-Message-State: AOJu0YydewciJCNMphRU4/kR1TtIv5VgzKlpQlYRcWWAqrFoMt6Zx6eD
	2nJMbl1Dy4YaRNWUrWkHqkOQbqZmd1YY0AcXUCiyDW1ZF7pIcu0nYZ27
X-Gm-Gg: ASbGnctbbSlGPuZ6xA/SzEv33FfZQCfVGYJB0azW7vIp06UPxvOmfnObP70VRwrUc8q
	lQ8Oz3ZfUiPvfQIYeYuWy5wHzzIk+x+kcYknriJMqsQzGBoShYIEG/kX7rHlor61nn7CX9AEDei
	gGLkeEwAa8L7nDc/ngsYhibShqA77A7+pEWD4Vi23l040mhWzkgRRXfpvZYUUteHbOjslK4gS6o
	tVhm8KPy7c7O5z8MAm/2xMMuQ2+pfdJ4KXlRWvupIWZ84nL8G96TclUITTqlHtX0Okqkv+ECFBg
	ktMSZ9RXKKS0Jn2Nzhn8UtiZ1dP/IeowyrGgJV8Ca+Gn88BclSRilQJSw6boRhe3ZAwAvuRjO8D
	x+FMi7Fc9mroYrV5tJLwUNihNm1rFH0lx2ji2YlM65c5jb3tA1Y5BsZYpLc+vs0nDxLum90xAE7
	HvH1gTN/SfbgTN2HgdhtN4RJG67+yeD1S8piX28DWI
X-Google-Smtp-Source: AGHT+IFz8nt5lSaN1IZMi/HsyQiO/U2toGtsPJ9LocnUEVg7UoKo9HQ8SO2vu6OgO8y7PKk852qrzQ==
X-Received: by 2002:a05:6000:2405:b0:426:d5ac:8660 with SMTP id ffacd0b85a97d-42704e0eed1mr9832421f8f.58.1760978275077;
        Mon, 20 Oct 2025 09:37:55 -0700 (PDT)
Received: from [192.168.0.100] ([188.27.132.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a993sm16100829f8f.24.2025.10.20.09.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 09:37:54 -0700 (PDT)
Message-ID: <0d8d7420-8a39-457f-a5a5-980a40809527@gmail.com>
Date: Mon, 20 Oct 2025 19:37:27 +0300
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/63] kbuild: Remove 'kmod_' prefix from
 __KBUILD_MODNAME
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
 laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
 Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
 Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan
 <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada <masahiroy@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
From: Cosmin Tanislav <demonsingur@gmail.com>
Content-Language: en-US
In-Reply-To: <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/25 7:03 PM, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, remove the arbitrary
> 'kmod_' prefix from __KBUILD_MODNAME and instead add it explicitly in
> the __initcall_id() macro.
> 
> This change supports the standardization of "unique" symbol naming by
> ensuring the non-unique portion of the name comes before the unique
> part.  That will enable objtool to properly correlate symbols across
> builds.
> 
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>   include/linux/init.h | 3 ++-
>   scripts/Makefile.lib | 2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 17c1bc712e234..40331923b9f4a 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -200,12 +200,13 @@ extern struct module __this_module;
>   
>   /* Format: <modname>__<counter>_<line>_<fn> */
>   #define __initcall_id(fn)					\
> +	__PASTE(kmod_,						\
>   	__PASTE(__KBUILD_MODNAME,				\
>   	__PASTE(__,						\
>   	__PASTE(__COUNTER__,					\
>   	__PASTE(_,						\
>   	__PASTE(__LINE__,					\
> -	__PASTE(_, fn))))))
> +	__PASTE(_, fn)))))))
>   
>   /* Format: __<prefix>__<iid><id> */
>   #define __initcall_name(prefix, __iid, id)			\
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 1d581ba5df66f..b955602661240 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -20,7 +20,7 @@ name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
>   name-fix = $(call stringify,$(call name-fix-token,$1))
>   basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
>   modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname)) \
> -		 -D__KBUILD_MODNAME=kmod_$(call name-fix-token,$(modname))
> +		 -D__KBUILD_MODNAME=$(call name-fix-token,$(modname))

As others have mentioned, this breaks modules.alias generation.

The following diff seems to fix it, although in introduces a slight
functional change if symbols do not actually follow the naming scheme.

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index b3333560b95e..c3c06b944c69 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1489,14 +1489,11 @@ void handle_moddevtable(struct module *mod, 
struct elf_info *info,
  	if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
  		return;

-	/* All our symbols are of form 
__mod_device_table__kmod_<modname>__<type>__<name>. */
+	/* All our symbols are of form 
__mod_device_table__<modname>__<type>__<name>. */
  	if (!strstarts(symname, prefix))
  		return;

-	modname = strstr(symname, "__kmod_");
-	if (!modname)
-		return;
-	modname += strlen("__kmod_");
+	modname = symname + strlen(prefix);

  	type = strstr(modname, "__");
  	if (!type)

It would seem like rust generated symbols don't follow it exactly?

See module_device_table macro in rust/kernel/device_id.rs.

>   modfile_flags  = -DKBUILD_MODFILE=$(call stringify,$(modfile))
>   
>   _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(target-stem).o), \


