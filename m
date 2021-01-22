Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D29300221
	for <lists+live-patching@lfdr.de>; Fri, 22 Jan 2021 12:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbhAVLz6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jan 2021 06:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbhAVK7y (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jan 2021 05:59:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 621152246B;
        Fri, 22 Jan 2021 10:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611313153;
        bh=ToPFueIhXgEfx/oW5tXGyVwgF7YBY5yyAHNHMR2G0xU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=SyOhdn1Yxd69mDdaLrB5sZIcPLIJjXbcgQmJ7omvyscplZvo0hHGcvdHrYBENuRZH
         cl74KtomsfjD/FAapiELLsd8h2QqHcGOnDc/TSZIJWI+0aMbuF24YnqY+QwXEoyppo
         CKYbuBnObOvbzXH2OPHZmakfFEC+ODood3iPHVHbRFhDdSSVMyEWjqBIegj9o7qhkj
         j1hOHJAoovJkbJeZr7/EBbE+8crdHrIBSEPLO+Xba37PkLcR5jwTj9d5FytG3pKML0
         6ykHKEnZx0GSKoI79a5TqOUft8kSao/33ZHmS+EaWKzSVMYUXEm5I2mCmZWdTmajVp
         lasGnkCo8O3Xw==
Date:   Fri, 22 Jan 2021 11:59:09 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Documentation: livepatch: Document reliable
 stacktrace and minor cleanup
In-Reply-To: <20210121115226.565790ef@lwn.net>
Message-ID: <nycvar.YFH.7.76.2101221158450.5622@cbobk.fhfr.pm>
References: <20210120164714.16581-1-broonie@kernel.org> <20210121115226.565790ef@lwn.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 21 Jan 2021, Jonathan Corbet wrote:

> > This series adds a document, mainly written by Mark Rutland, which 
> > makes explicit the requirements for implementing reliable stacktrace 
> > in order to aid architectures adding this feature.  It also updates 
> > the other livepatching documents to use automatically generated tables 
> > of contents following review comments on Mark's document.
> 
> So...is this deemed ready and, if so, do you want it to go through the
> docs tree or via some other path?

I am planning to take it through livepatching tree unless there are any 
additional last-minutes comments.

Thanks,

-- 
Jiri Kosina
SUSE Labs

