Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678F95059D
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2019 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfFXJ1h (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Jun 2019 05:27:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:53548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfFXJ1g (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Jun 2019 05:27:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 993F9AC66;
        Mon, 24 Jun 2019 09:27:35 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] livepatch: new API to track system state changes
References: <20190611135627.15556-1-pmladek@suse.com>
Date:   Mon, 24 Jun 2019 11:27:34 +0200
In-Reply-To: <20190611135627.15556-1-pmladek@suse.com> (Petr Mladek's message
        of "Tue, 11 Jun 2019 15:56:22 +0200")
Message-ID: <87o92n49kp.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

> this is another piece in the puzzle that helps to maintain more
> livepatches.
>
> Especially pre/post (un)patch callbacks might change a system state.
> Any newly installed livepatch has to somehow deal with system state
> modifications done be already installed livepatches.
>
> This patchset provides, hopefully, a simple and generic API that
> helps to keep and pass information between the livepatches.
> It is also usable to prevent loading incompatible livepatches.

I like it a lot, many thanks for doing this!

Minor remarks/questions will follow inline.

Nicolai
