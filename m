Return-Path: <live-patching+bounces-383-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE97792AB4C
	for <lists+live-patching@lfdr.de>; Mon,  8 Jul 2024 23:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9692E282E23
	for <lists+live-patching@lfdr.de>; Mon,  8 Jul 2024 21:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC8414900C;
	Mon,  8 Jul 2024 21:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oX6noqEE"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FFF145B06;
	Mon,  8 Jul 2024 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720474390; cv=none; b=GqiAejllV/d52P0kRAK57jRChxPVkf0ZMUw5qea//WGgq8EADQcYB6nCxuDxfpMW0GEs4Ar5uAC4a0PzB9TtWEgXjHTe+MCBxid75esVyifgONDG5fSfZ7TVwGGnuevKTyOkch/SiK9U+In6aT8eQMkjTsxnIkAogDqGsLWKx6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720474390; c=relaxed/simple;
	bh=TcFuRSTouqSwSOmRTlwDAsZ9GRoQgaD5Uu02hQc1P3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRSVw78RWMNx0/UeQPUE7QDDYEvuUaJA3QBWkLE4AQd9r+l47k+sk4ER3b3SKKuT9uz+gFj/r06uuqiowRONEQG6OnzV/G7iSWOXIcgbVJzY50uroRM40BIruqv948u7ZDu9I78AuCjFWI/vEq98XzRZda0Or0Sme8Naaauv3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oX6noqEE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k5N0yQEeYkHaqgLUPdx8ohjlAolybjVdZKO1rXci5D0=; b=oX6noqEEtkrqiNk9WsehAh9fU9
	qmIF06HH93Da1K4XQ961XcjoLSGcQ6hxgwlFpP6WEU8NIXTYB7oPxnvBuEKHkQw/YHCz3wLp8eBUb
	HNKSKT4rqLY26MLoxT15prosWc7m4x1UjeK6qxAhd0o6IId2K+K8KpLjOeCWjnkV1Da/4j/nro/IW
	7l2kG6EXqo/sBU7jNVtT0XzwmY4rY/KaYLMHuImXjCMx1xI+UhajQCmJRsZ/P5GKHcy+z54pxAl60
	8WzIgKiAtZNKYPkpwHZpLWae4e4PJAlAbP3J52QAiUexJ4JKgChqw7R6FOMWoBx8+FnIFwuhBYpJx
	uiHNcZ2A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sQvyq-000000055sA-0DEu;
	Mon, 08 Jul 2024 21:33:04 +0000
Date: Mon, 8 Jul 2024 14:33:04 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Petr Mladek <pmladek@suse.com>, Sami Tolvanen <samitolvanen@google.com>,
	Gary Guo <gary@garyguo.net>, Masahiro Yamada <masahiroy@kernel.org>,
	Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Andreas Hindborg <nmi@metaspace.dk>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>, Song Liu <song@kernel.org>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com, nathan@kernel.org,
	morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Message-ID: <ZoxbEEsK40ASi1cY@bombadil.infradead.org>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
 <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
 <ZoKrWU7Gif-7M4vL@pathway.suse.cz>
 <20240703055641.7iugqt6it6pi2xy7@treble>
 <ZoVumd-b4CaRu5nW@bombadil.infradead.org>
 <ZoZlGnVDzVONxUDs@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoZlGnVDzVONxUDs@pathway.suse.cz>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Jul 04, 2024 at 11:02:18AM +0200, Petr Mladek wrote:
> On Wed 2024-07-03 08:30:33, Luis Chamberlain wrote:
> > On Tue, Jul 02, 2024 at 10:56:41PM -0700, Josh Poimboeuf wrote:
> > > On Mon, Jul 01, 2024 at 03:13:23PM +0200, Petr Mladek wrote:
> > > > So, you suggest to search the symbols by a hash. Do I get it correctly?
> > 
> > I meant, that in the Rust world the symbols go over the allowed limit,
> > and so an alternative for them is to just use a hash. What I'm
> > suggesting is for a new kconfig option where that world is the
> > new one, so that they have to also do the proper userspace tooling
> > for it. Without that, I don't see it as properly tested or scalable.
> > And if we're gonna have that option for Rust for modules, then it begs
> > the question if this can be used by other users.
> 
> I am still not sure at which level the symbol names would get hashed ;-)

Let's clarify that. The Rust world mangles symbols to be very long. In
order to allow external modules built to be usable in other systems we support
modversioning. To help with this each module has an array of crcs of each
symbol it depends on. This is added to the module.mod.c so for my built
xfs.mod.c I have for example:

static const struct modversion_info ____versions[]
__used __section("__versions") = {
{ 0x5b8239ca, "__x86_return_thunk" },
{ 0x93a6e0b2, "io_schedule" }, 
{ 0x6383b27c, "__x86_indirect_thunk_rdx" },
{ 0xc5b6f236, "queue_work_on" },
{ 0xd966a5ea, "list_lru_walk_one" },
...
{ 0xe3565824, "vfs_readlink" },
{ 0xaed0dc33, "bdev_freeze" },
{ 0x7ce18c9f, "from_kqid" },
{ 0xd36dc10c, "get_random_u32" },
{ 0xba4edeaf, "__percpu_down_read" },
{ 0xb9f07b78, "file_modified" },
{ 0x48755bd1, "module_layout"
},
};

If a module depends on a symbol from a Rust module or Rust built-in
code, it cannot fit becuase we currenlty define:

struct modversion_info {                                                         
	unsigned long crc;                                                       
	char name[MODULE_NAME_LEN];                                              
};  

Although perhaps this started off as thing for module versions only,
clearly we're using it for all symbols a module uses so MODULE_NAME_LEN
really was in the end silly and does not suffice today.

A version of the effort from Rust folks last year tried to modify the
length but its claimed that the blocker for that was that userspace
would need to change, so their new attempt tried to work around that
using hashes...

Looking at this again its not to me why Masahiro Yamada's suggestion on
that old patch series to just increase the length and put long symbols
names into its own section [0] could not be embraced with a new kconfig
option, so new kernels and new userspace could support it:

https://lore.kernel.org/lkml/CAK7LNATsuszFR7JB5ZkqVS1W=hWr9=E7bTf+MvgJ+NXT3aZNwg@mail.gmail.com/

> The symbols names are used in many situations, e.g. backtraces,
> crashdump, objdump, nm, gdb, tracing, livepatching, kprobes, ...
> 
> Would kallsyms provide some translation table between the usual
> "long" symbol name and a hash?
> 
> Would it allows to search the symbols both ways?

Let's review the scope of both issues first, certainly Rust's issue is
limitted in scope, but since a new userspace change might be required
its worth reviewing if it may help the CONFIG_LTO_CLANG case as well.

> I am a bit scared because using hashed symbol names in backtraces, gdb,
> ... would be a nightmare. Hashes are not human readable and
> they would complicate the life a lot. And using different names
> in different interfaces would complicate the life either.

All great points.

The scope of the Rust issue is self contained to modversion_info,
whereas for CONFIG_LTO_CLANG issue commit 8b8e6b5d3b013b0
("kallsyms: strip ThinLTO hashes from static functions") describes
the issue with userspace tools (it doesn't explain which ones)
which don't expect the function name to change. This seems to happen
to static routines so I can only suspect this isn't an issue with
modversioning as the only symbols that would be used there wouldn't be
static.

Sami, what was the exact userspace issue with CONFIG_LTO_CLANG and these
long symbols?

  Luis

