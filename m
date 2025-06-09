Return-Path: <live-patching+bounces-1505-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E468AAD2A67
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 01:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C677B3B1D6C
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 23:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44A522A4D2;
	Mon,  9 Jun 2025 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHt8cyTQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0DC226D09;
	Mon,  9 Jun 2025 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749511275; cv=none; b=utPb1pat3H4Subdcxu7jhMeXEv4TKIGgRgP/gYQAbE3yWPkiYj3j9oMvrraFGUkqQkmhDAlz1mP5OWD2PcxQO462XxjX35/j0E+s//cwJuX7L3Oit86VWwV2XTL/aUZuQgNeJr+8qqfr4nq7LePMBSxJEecI2PwDz5jb1x131IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749511275; c=relaxed/simple;
	bh=t/0TK/aXnW9B9Zvjni3rqnbmiMIAuNBhtmaoYddFqfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ds9gOPQAspst+Bf8g+tq6OD3jVjNKXECnLw0jWkmirXaP9rjWBmqGot612bKnr159cInDFNgnhSFaFHgtQ9rvC+wiZe4EB0Kr20DZX5mO0D92tgD5TQu7AVngSsp+7fQu48SALy8GnT5623U/8uVao3gtLf3LvZ3llbrDcISFPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHt8cyTQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C21BC4CEEB;
	Mon,  9 Jun 2025 23:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749511274;
	bh=t/0TK/aXnW9B9Zvjni3rqnbmiMIAuNBhtmaoYddFqfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHt8cyTQOHGMTxo94G8J/zdicSC8ewUocWIhP83xkkYfwrL40uRY58PTBkoeEgvaq
	 5fr/H2g1hnDAZshICdgEiHF9Km3gwwkfJAC/l0MTOl/4199UOlgHrW4h9j/WZQKvGX
	 uT3UwEN7e0j4v72so8flDqhWntky1Trx0xgQAK6Ej2HKEZwXwZHBHPefr5K9e7FwIl
	 ZdrHE5l922XdKUaXfXpY91ag1MfpYFtZCDo13H5qElA1ibohl7lwKfhvcTKoy7KK/Q
	 nM+yEmB0SaFeKWA2kXU0FTQ/fyb0k0E5cBjZGTJR0s+QyFTT+f0z+yCRY2oSXmIlJ1
	 sxnkQO7sFHbTg==
Date: Mon, 9 Jun 2025 16:21:11 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <2oublab5wrfzneispi4sqb6feiw2abc3mzxozmx53btuvseljh@3qsmyluomyir>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <aEcos4fig5KVDQSp@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aEcos4fig5KVDQSp@redhat.com>

On Mon, Jun 09, 2025 at 02:32:19PM -0400, Joe Lawrence wrote:
> On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> > +static int validate_ffunction_fdata_sections(struct elf *elf)
> > +{
> > +	struct symbol *sym;
> > +	bool found_text = false, found_data = false;
> > +
> > +	for_each_sym(elf, sym) {
> > +		char sec_name[SEC_NAME_LEN];
> > +
> > +		if (!found_text && is_func_sym(sym)) {
> > +			snprintf(sec_name, SEC_NAME_LEN, ".text.%s", sym->name);
> > +			if (!strcmp(sym->sec->name, sec_name))
> > +				found_text = true;
> > +		}
> > +
> > +		if (!found_data && is_object_sym(sym)) {
> > +			snprintf(sec_name, SEC_NAME_LEN, ".data.%s", sym->name);
> > +			if (!strcmp(sym->sec->name, sec_name))
> > +				found_data = true;
> 
> Hi Josh,
> 
> Should we check for other data section prefixes here, like:
> 
> 			else {
> 				snprintf(sec_name, SEC_NAME_LEN, ".rodata.%s", sym->name);
> 				if (!strcmp(sym->sec->name, sec_name))
> 					found_data = true;
> 			}

Indeed.  And also .bss.*.

> At the same time, while we're here, what about other .text.* section
> prefixes?

AFAIK, .text.* is the only one.

-- 
Josh

